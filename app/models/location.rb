class Location < ActiveRecord::Base
  belongs_to :locatable, :polymorphic => true

  # TODO: Add validation, presence of image, x1,y1,x2,y2 must be positive

end
