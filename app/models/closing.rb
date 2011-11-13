class Closing < ActiveRecord::Base
  has_one :task

  validates :responsible, :presence => true
  validates :support_doc, :presence => true
end
