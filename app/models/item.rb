class Item < ActiveRecord::Base

  include CsvSerialize::InstanceMethods
  CsvColumns = %w[name kind part.number part.description]

  Kinds = %w[Seat Lavatory Carpet Panel Sidewall Label]

  attr_accessible :name, :kind, :part_id

  belongs_to :zone
  belongs_to :part
  has_one :location, :as => :locatable, :dependent => :destroy

  validates :name, :presence => true, :uniqueness => { :scope => :zone_id }
  validates :kind, :inclusion => { :in => Kinds }
  validates :part, :presence => true

  scope :sort_natural, order("kind, LPAD(SUBSTRING(name from '[0-9]+'),5, '0'), SUBSTRING(name from '[^0-9]+')")
end
