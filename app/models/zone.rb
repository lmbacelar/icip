class Zone < ActiveRecord::Base

  include CsvSerialize::InstanceMethods
  CsvColumns = %w[name description inspection_interval]

  attr_accessible :name, :description, :inspection_interval, :images_attributes, :items_attributes

  belongs_to :konfiguration
  #has_many  :items, :dependent => :destroy
  has_many  :images, :as => :imageable, :dependent => :destroy
  #accepts_nested_attributes_for :items, :reject_if => lambda { |i| i[:name].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :images, :reject_if => lambda { |i| i[:file].blank? }, :allow_destroy => true

  validates :name, :presence => true, :uniqueness => {:scope => :konfiguration_id}
  validates :inspection_interval, :presence => true, :numericality => { :only_integer => true,
                                                                        :greater_than => 0,
                                                                        :less_than => 366 }

  scope :asc, order('name ASC')
  scope :desc, order('name DESC')

end
