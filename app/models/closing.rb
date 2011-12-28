class Closing < ActiveRecord::Base
  # # # # # Includes / Extends          # # # # #
  # # # # # Constants                   # # # # #
  # # # # # Instance Variables          # # # # #
  # # # # # Callbacks                   # # # # #
  # # # # # Attr_accessible / protected # # # # #
  # # # # # Associations / Delegates    # # # # #
  # # # # # Scopes                      # # # # #
  # # # # # Validations                 # # # # #
  # # # # # Public Methods              # # # # #
  # # # # # Private Methods             # # # # #
  belongs_to :engineer, class_name: 'User'
  has_one :tasc

  # # # # # Scopes                      # # # # #

  # # # # # Validations                 # # # # #
  validates :engineer, presence: true
  validates :support_doc, presence: true

  # # # # # Public Methods              # # # # #
  # # # # # Private Methods             # # # # #
end
