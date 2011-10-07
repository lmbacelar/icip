require 'file_size_validator'
class Image < ActiveRecord::Base
  before_validation :update_checksum

  has_many :image_assignments, :dependent => :destroy

  mount_uploader :file, ImageUploader

  validates :file, :file_size => { :maximum => 5.megabytes.to_i }
  validates :checksum, :presence => true, :uniqueness => true

  def self.checksum(url)  Digest::MD5.hexdigest File.read(url)                  end

private
  def update_checksum()   self.checksum = Image.checksum "public#{file.to_s}"   end
end
