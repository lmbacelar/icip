class Konfiguration < ActiveRecord::Base

  include CsvSerialize::InstanceMethods
  CsvColumns = %w[number description]

  attr_accessible :number, :description, :zones_attributes

  belongs_to :aircraft
  has_many  :zones, :dependent => :destroy
  accepts_nested_attributes_for :zones, :reject_if => lambda { |z| z[:name].blank? }, :allow_destroy => true

  validates :number, :presence => true, :uniqueness => {:scope => :aircraft_id}
  validates :description, :presence => true, :uniqueness => {:scope => :aircraft_id}

  scope :newest, order('number DESC')
  scope :oldest, order('number ASC')

  def self.current
    newest.first
  end
  def current?
    self == self.aircraft.konfigurations.current
  end
  def self.obsolete
    newest.slice(1, newest.count-1)
  end
  def obsolete?
    !(new_record? || current?)
  end

end
