class Part < ActiveRecord::Base
  attr_accessible :number, :description

  has_many  :items, :dependent => :destroy
  accepts_nested_attributes_for :items, :reject_if => lambda { |i| i[:name].blank? }, :allow_destroy => true

  validates :number, :presence => true, :uniqueness => true

  default_scope order('number ASC')

  def to_s
    number
  end
end
