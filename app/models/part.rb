class Part < ActiveRecord::Base

  extend  CsvSerialize::ClassMethods
  CsvColumns = %w[number kind description]

  attr_accessible :number, :kind, :description

  Kinds = %w[Seat Lavatory Carpet Panel Sidewall Label]

  has_many  :items, :dependent => :destroy
  accepts_nested_attributes_for :items, :reject_if => lambda { |i| i[:name].blank? }, :allow_destroy => true
  has_many  :protocols, :dependent => :destroy
  accepts_nested_attributes_for :protocols, :reject_if => lambda { |p| p[:revnum].blank? }, :allow_destroy => true
  has_one :checkpoint, :dependent => :destroy

  validates :number, :presence => true, :uniqueness => true
  validates :kind, :inclusion => { :in => Kinds }

  default_scope order('number ASC')

  def to_s
    number
  end
end
