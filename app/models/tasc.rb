class Tasc < ActiveRecord::Base

  Actions = %w[Repair Replace]
  Etrs = %w[1 4 A C]

  belongs_to :inspection
  belongs_to :item
  belongs_to :checkpoint
  belongs_to :closing
  belongs_to :technician, class_name: 'User'

  validates :technician, presence: true
  validates :action, inclusion: { in: Actions }
  validates :etr, inclusion: { in: Etrs }
  validates :inspection, presence: true
  validates :item, presence: true
  validates :checkpoint, presence: true

  scope :pending, where('tascs.closing_id IS NULL')
  scope :closed, where('tascs.closing_id IS NOT NULL')

  def closed?
    not open?
  end

  def open?
    closing.nil?
  end
end
