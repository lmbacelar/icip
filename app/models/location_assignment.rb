class LocationAssignment < ActiveRecord::Base
  belongs_to :location
  belongs_to :locatable, polymorphic: true
end
