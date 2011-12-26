require 'file_size_validator'
class Image < ActiveRecord::Base
  include CsvSerialize::InstanceMethods
  CsvColumns = %w[]

  before_validation :update_checksum

  has_many :image_assignments, dependent: :destroy
  has_many :locations, dependent: :destroy
  accepts_nested_attributes_for :locations, reject_if: lambda { |o| o[:x1].nil? ||
                                                                    o[:y1].nil? ||
                                                                    o[:x2].nil? ||
                                                                    o[:y2].nil? }, allow_destroy: true
  mount_uploader :file, ImageUploader

  validates :file, file_size: { maximum: 5.megabytes.to_i }
  validates :checksum, presence: true, uniqueness: true

  def self.checksum(url)  Digest::MD5.hexdigest File.read(url)                  end

private
  def update_checksum()   self.checksum = Image.checksum "public#{file.to_s}"   end
end
