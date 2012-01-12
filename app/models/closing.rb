class Closing < ActiveRecord::Base
  # # # # # Includes / Extends          # # # # #
  # # # # # Constants                   # # # # #
  # # # # # Instance Variables          # # # # #
  # # # # # Callbacks                   # # # # #
  after_create :update_inspection_index
  after_destroy :update_inspection_index

  # TODO: Fix these. Not updating Tasc tire index
  after_create :update_tasc_index
  after_destroy :update_tasc_index

  # # # # # Attr_accessible / protected # # # # #
  # # # # # Associations / Delegates    # # # # #
  # # # # # Scopes                      # # # # #
  # # # # # Validations                 # # # # #
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
  def update_inspection_index
    self.tasc.inspection.tire.update_index
  end

  def update_tasc_index
    self.tasc.tire.update_index
  end
end
