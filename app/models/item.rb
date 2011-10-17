class Item < ActiveRecord::Base

  include CsvSerialize::InstanceMethods
  CsvColumns = %w[name kind part.number part.description location.image location.x1 location.y1 location.x2 location.y2]

  Kinds = %w[Seat Lavatory Carpet Panel Sidewall Label]

  attr_accessible :name, :kind, :part_id, :location, :location_attributes

  belongs_to :zone
  belongs_to :part
  has_one :location, :as => :locatable, :dependent => :destroy
  accepts_nested_attributes_for :location, :reject_if => lambda { |o| o[:x1].nil? ||
                                                                      o[:y1].nil? ||
                                                                      o[:x2].nil? ||
                                                                      o[:y2].nil? }, :allow_destroy => true

  validates :name, :presence => true, :uniqueness => { :scope => :zone_id }
  validates :kind, :inclusion => { :in => Kinds }
  validates :part, :presence => true

  scope :sort_natural, order("kind, LPAD(SUBSTRING(name from '[0-9]+'),5, '0'), SUBSTRING(name from '[^0-9]+')")
  scope :locatable, lambda { self.joins("JOIN locations ON items.id = locations.locatable_id") }
  scope :at_position, lambda { |x,y| locatable.where("locations.x1 <= #{x} AND locations.x2 >= #{x} AND locations.y1 <= #{y} AND locations.y2 >= #{y}") }
end
