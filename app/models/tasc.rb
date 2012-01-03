class Tasc < ActiveRecord::Base
  # # # # # Includes / Extends          # # # # #
  # # # # # Constants                   # # # # #
  # # # # # Instance Variables          # # # # #
  Actions = %w[Repair Replace]
  Etrs = %w[1 4 A C]

  # # # # # Callbacks                   # # # # #
  # # # # # Attr_accessible / protected # # # # #
  # # # # # Associations / Delegates    # # # # #
  belongs_to :inspection
  belongs_to :item
  belongs_to :checkpoint
  belongs_to :closing
  belongs_to :technician, class_name: 'User'

  # # # # # Scopes                      # # # # #
  scope :pending, where('tascs.closing_id IS NULL')
  scope :closed, where('tascs.closing_id IS NOT NULL')

  # # # # # Validations                 # # # # #
  validates :technician, presence: true
  validates :action, presence: true, inclusion: { in: Actions }
  validates :etr, presence: true, inclusion: { in: Etrs }
  validates :inspection, presence: true
  validates :item, presence: true
  validates :checkpoint, presence: true
  validates :checkpoint_id, uniqueness: { scope: [:inspection_id, :item_id] }

  # # # # # Public Methods              # # # # #
  def open?
    closing.nil?
  end

  def closed?
    not open?
  end

  # # # # # Private Methods             # # # # #
  private
end
