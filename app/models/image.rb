require 'file_size_validator'
class Image < ActiveRecord::Base
  belongs_to :imageable, :polymorphic => true
  mount_uploader :file, ImageUploader
  validates :file, :file_size => { :maximum => 5.megabytes.to_i }

  ##
  #
  # TODO: Check if image exists (File compare before upload) and
  #       associate with existing instead of creating new.
  #

end
