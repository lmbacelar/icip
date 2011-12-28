class LocationAssignment < ActiveRecord::Base
  # # # # # Includes / Extends          # # # # #
  # # # # # Constants                   # # # # #
  # # # # # Instance Variables          # # # # #
  # # # # # Callbacks                   # # # # #
  # # # # # Attr_accessible / protected # # # # #
  # # # # # Associations / Delegates    # # # # #
  belongs_to :location
  belongs_to :locatable, polymorphic: true

  # # # # # Scopes                      # # # # #
  # # # # # Validations                 # # # # #
  # # # # # Public Methods              # # # # #
  # # # # # Private Methods             # # # # #
end
