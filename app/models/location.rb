class Location < ActiveRecord::Base

  include CsvSerialize::InstanceMethods
  CsvColumns = %w[name x1 y1 x2 y2]

  belongs_to :image
  # belongs_to :locatable, :polymorphic => true
  # has_one :image_assignment, :as => :imageable, :dependent => :destroy
  # has_one :image, :through => :image_assignment, :dependent => :destroy

  validates :name, :presence => true, :uniqueness => {:scope => :image_id}
  validates :image, :presence => true
  validates :x1, :inclusion => { :in => 0..1.0/0, :message => 'should be positive' }
  validates :y1, :inclusion => { :in => 0..1.0/0, :message => 'should be positive' }
  validates :x2, :inclusion => { :in => 0..1.0/0, :message => 'should be positive' }
  validates :y2, :inclusion => { :in => 0..1.0/0, :message => 'should be positive' }

  scope :sort_natural, order("LPAD(SUBSTRING(name from '[0-9]+'),5, '0'), SUBSTRING(name from '[^0-9]+')")

  def image_id
    image.try(:id)
  end

end
