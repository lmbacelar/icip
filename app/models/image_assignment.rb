class ImageAssignment < ActiveRecord::Base
  # # # # # Includes / Extends          # # # # #
  # # # # # Constants                   # # # # #
  # # # # # Instance Variables          # # # # #
  # # # # # Callbacks                   # # # # #
  # # # # # Attr_accessible / protected # # # # #
  # # # # # Associations / Delegates    # # # # #
  belongs_to :image
  belongs_to :imageable, polymorphic: true

  # # # # # Scopes                      # # # # #
  # # # # # Validations                 # # # # #
  # # # # # Public Methods              # # # # #
  # # # # # Private Methods             # # # # #
end
