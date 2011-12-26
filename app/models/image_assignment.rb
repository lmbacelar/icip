class ImageAssignment < ActiveRecord::Base
  belongs_to :image
  belongs_to :imageable, polymorphic: true
end
