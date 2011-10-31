class Part < ActiveRecord::Base

  extend  CsvSerialize::ClassMethods
  CsvColumns = %w[number description]

  attr_accessible :number, :description

  has_many  :items, :dependent => :destroy
  accepts_nested_attributes_for :items, :reject_if => lambda { |i| i[:name].blank? }, :allow_destroy => true
  has_many  :protocols, :dependent => :destroy
  accepts_nested_attributes_for :protocols, :reject_if => lambda { |p| p[:revnum].blank? }, :allow_destroy => true
  has_one :checkpoint, :dependent => :destroy

  validates :number, :presence => true, :uniqueness => true

  default_scope order('number ASC')

  def to_s
    number
  end
end
