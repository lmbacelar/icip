class Zone < ActiveRecord::Base

  CsvColumns = %w[name description inspection_interval]

  attr_accessible :name, :description, :inspection_interval, :items_attributes

  belongs_to :configuration
  has_many  :items, :dependent => :destroy
  accepts_nested_attributes_for :items, :reject_if => lambda { |i| i[:name].blank? }, :allow_destroy => true

  validates :name, :presence => true, :uniqueness => {:scope => :configuration_id}

end
