class Aircraft < ActiveRecord::Base

  extend  CsvSerialize::ClassMethods
  include CsvSerialize::InstanceMethods
  CsvColumns = %w[registration manufacturer model]

  attr_accessible :registration, :manufacturer, :model, :konfigurations_attributes

  has_many  :konfigurations, :dependent => :destroy
  accepts_nested_attributes_for :konfigurations, :reject_if => lambda { |c| c[:number].blank? }, :allow_destroy => true

  validates :registration, :presence => true, :uniqueness => true

end
