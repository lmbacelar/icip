require 'file_size_validator'
class Image < ActiveRecord::Base
  belongs_to :imageable, :polymorphic => true
  mount_uploader :file, ImageUploader
  validates :file, :file_size => { :maximum => 5.megabytes.to_i }
end
