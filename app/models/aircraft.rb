class Aircraft < ActiveRecord::Base

  extend  CsvSerialize::ClassMethods
  include CsvSerialize::InstanceMethods
  CsvColumns = %w[registration manufacturer model]

  attr_accessible :registration, :manufacturer, :model, :konfigurations_attributes

  has_many  :konfigurations, :dependent => :destroy
  accepts_nested_attributes_for :konfigurations, :reject_if => lambda { |c| c[:number].blank? }, :allow_destroy => true
  has_many :zones, :through => :konfigurations
  has_many :inspections, :through => :zones
  has_many :tascs, :through => :inspections

  validates :registration, :presence => true, :uniqueness => true

end
