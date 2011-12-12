class Closing < ActiveRecord::Base
  belongs_to :engineer, :class_name => 'User'
  has_one :task

  validates :engineer, :presence => true
  validates :support_doc, :presence => true
end
