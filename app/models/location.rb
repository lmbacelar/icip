class Location < ActiveRecord::Base
  belongs_to :locatable, :polymorphic => true
  has_one :image_assignment, :as => :imageable, :dependent => :destroy
  has_one :image, :through => :image_assignment, :dependent => :destroy

  # TODO: Add validation, presence of image, x1,y1,x2,y2 must be positive

  def image_id
    image.try(:id)
  end

end