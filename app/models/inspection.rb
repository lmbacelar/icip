class Inspection < ActiveRecord::Base
  belongs_to :zone
  has_many :tasks, :dependent => :destroy
  accepts_nested_attributes_for :tasks, :reject_if => lambda { |t| t[:action].blank? ||
                                                                   t[:technician] }, :allow_destroy => true

  scope :scheduled, where('inspections.completed = FALSE')
  scope :completed, where('inspections.completed = TRUE')
  scope :pending, joins(:tasks).merge(Task.pending)
  scope :closed, joins(:tasks).merge(Task.closed)
end
