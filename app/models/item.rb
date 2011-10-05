class Item < ActiveRecord::Base

  include CsvSerialize::InstanceMethods
  CsvColumns = %w[name kind]

  ItemKinds = %w[Seat Lavatory Carpet Panel Sidewall Label]

  attr_accessible :name, :kind, :part_id

  belongs_to :zone
  belongs_to :part
#  has_one :location, :dependent => :destroy

  validates :name, :presence => true, :uniqueness => { :scope => :zone_id }
  validates :kind, :inclusion => { :in => ItemKinds }
  validates :part, :presence => true

  scope :sort_natural, order("kind, LPAD(SUBSTRING(name from '[0-9]+'),5, '0'), SUBSTRING(name from '[^0-9]+')")
end
