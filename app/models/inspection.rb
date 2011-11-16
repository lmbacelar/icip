class Inspection < ActiveRecord::Base
  belongs_to :zone
  has_many :tasks, :dependent => :destroy
  accepts_nested_attributes_for :tasks, :reject_if => lambda { |t| t[:action].blank? ||
                                                                   t[:technician] }, :allow_destroy => true
  scope :scheduled, where('inspections.executed = FALSE')
  scope :executed, where('inspections.executed = TRUE')
  scope :pending, executed.joins(:tasks).merge(Task.pending)
  #
  # TODO:
  # Inspections without findings (no tasks) should be closed as soon as marked executed.
  # These are not included in this scope. Include them.
  scope :closed, executed.joins(:tasks).merge(Task.closed)

  scope :clean, executed.where('id NOT IN (SELECT inspection_id FROM tasks)')
end
