require 'file_size_validator'
class Image < ActiveRecord::Base
  include CsvSerialize::InstanceMethods
  CsvColumns = %w[]

  before_validation :update_checksum

  has_many :image_assignments, dependent: :destroy
  has_many :protocols, through: :image_assignments, source: :imageable, source_type: 'Protocol'
  has_many :zones, through: :image_assignments, source: :imageable, source_type: 'Zone'
  has_many :locations, dependent: :destroy
  accepts_nested_attributes_for :locations, allow_destroy: true, reject_if: ->(o){ o[:x1].nil? ||
                                                                                   o[:y1].nil? ||
                                                                                   o[:x2].nil? ||
                                                                                   o[:y2].nil? }
  mount_uploader :file, ImageUploader

  validates :file, file_size: { maximum: 5.megabytes.to_i }
  validates :checksum, presence: true, uniqueness: true

  def self.checksum(url)  Digest::MD5.hexdigest File.read(url)                  end
  def name() File.basename file_url, '.*'                                       end
  def extname() File.extname(file_url).gsub('.', '')                            end
  def file_size
    if file.size > 1.megabyte
      "#{file.size / 1.megabyte} MB"
    else
      "#{file.size / 1.kilobyte} kB"
    end
  end


private
  def update_checksum()   self.checksum = Image.checksum "public#{file.to_s}"   end
end
