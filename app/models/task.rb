class Task < ActiveRecord::Base

  Actions = %w[Repair Replace]

  belongs_to :inspection
  belongs_to :item
  belongs_to :checkpoint
  belongs_to :closing
  belongs_to :technician, :class_name => 'User'

  validates :technician, :presence => true
  validates :action, :inclusion => { :in => Actions }
  validates :inspection, :presence => true
  validates :item, :presence => true
  validates :checkpoint, :presence => true

  scope :pending, where('tasks.closing_id IS NULL')
  scope :closed, where('tasks.closing_id IS NOT NULL')
end
