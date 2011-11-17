class Inspection < ActiveRecord::Base
  belongs_to :zone
  has_many :tasks, :dependent => :destroy
  accepts_nested_attributes_for :tasks, :reject_if => lambda { |t| t[:action].blank? ||
                                                                   t[:technician] }, :allow_destroy => true
  scope :scheduled, where('inspections.execution_date IS NULL')
  scope :executed, where('inspections.execution_date IS NOT NULL')
  scope :pending, executed.joins(:tasks).merge(Task.pending)
  scope :clean, executed.where('id NOT IN (SELECT inspection_id FROM tasks)')
  # Closed inspections are those with no tasks added to those with all tasks closed.
  scope :closed, clean + executed.joins(:tasks).merge(Task.closed)

  def executed
    execution_date.present?
  end

  def executed=(execd)
    if execd
      self.execution_date = Time.now
    else
      self.execution_date = nil
    end
  end
end
