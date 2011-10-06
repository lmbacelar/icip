require 'file_size_validator'
class Image < ActiveRecord::Base
  has_many :image_assignments
  has_many :imageables, :through => :image_assignments, :dependent => :destroy

  mount_uploader :file, ImageUploader
  validates :file, :file_size => { :maximum => 5.megabytes.to_i }

  ##
  #
  # TODO: Check if image exists (File compare before upload) and
  #       associate with existing instead of creating new.
  #

end
