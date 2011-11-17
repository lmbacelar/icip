class Inspection < ActiveRecord::Base
  belongs_to :zone
  has_many :tasks, :dependent => :destroy
  accepts_nested_attributes_for :tasks, :reject_if => lambda { |t| t[:action].blank? ||
                                                                   t[:technician] }, :allow_destroy => true
  scope :scheduled, where('inspections.assigned_to IS NULL')
  scope :assigned, where('inspections.assigned_to IS NOT NULL AND inspections.execution_date IS NULL')
  scope :executed, where('inspections.execution_date IS NOT NULL')
  scope :pending, executed.joins(:tasks).merge(Task.pending)
  scope :clean, executed.where('id NOT IN (SELECT inspection_id FROM tasks)')
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
