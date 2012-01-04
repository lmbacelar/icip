class InspectionAssignment < ActiveRecord::Base
  # # # # # Includes / Extends          # # # # #
  # # # # # Constants                   # # # # #
  # # # # # Instance Variables          # # # # #
  # # # # # Callbacks                   # # # # #
  # # # # # Attr_accessible / protected # # # # #
  # # # # # Associations / Delegates    # # # # #
  belongs_to :user
  belongs_to :inspection, touch: true

  # # # # # Scopes                      # # # # #
  # # # # # Validations                 # # # # #
  # # # # # Public Methods              # # # # #
  # # # # # Private Methods             # # # # #
end
