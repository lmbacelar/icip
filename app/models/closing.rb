class Closing < ActiveRecord::Base
  # # # # # Includes / Extends          # # # # #
  # # # # # Constants                   # # # # #
  # # # # # Instance Variables          # # # # #
  # # # # # Callbacks                   # # # # #
  after_create :update_indexes
  after_destroy :update_indexes

  # # # # # Attr_accessible / protected # # # # #
  # # # # # Associations / Delegates    # # # # #
  # # # # # Scopes                      # # # # #
  # # # # # Validations                 # # # # #
  validates :tasc_id, presence: true, uniqueness: true

  # # # # # Public Methods              # # # # #
  # # # # # Private Methods             # # # # #
  belongs_to :engineer, class_name: 'User'
  belongs_to :tasc, touch: true

  # # # # # Scopes                      # # # # #

  # # # # # Validations                 # # # # #
  validates :engineer, presence: true
  validates :support_doc, presence: true

  # # # # # Public Methods              # # # # #
  # # # # # Private Methods             # # # # #
private
  def update_indexes
    self.tasc.tire.update_index
    self.tasc.inspection.tire.update_index
  end
end
