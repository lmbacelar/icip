class Checkpoint < ActiveRecord::Base
  belongs_to :protocol
  belongs_to :part
  has_one :location, :as => :locatable, :dependent => :destroy
  accepts_nested_attributes_for :location, :reject_if => lambda { |o| o[:x1].nil? ||
                                                                      o[:y1].nil? ||
                                                                      o[:x2].nil? ||
                                                                      o[:y2].nil? }, :allow_destroy => true

  validates :number, :presence => true
  validates :part, :presence => true

  scope :sort_natural, order("LPAD(number, 5, '0') ASC")
end
