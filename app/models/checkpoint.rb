class Checkpoint < ActiveRecord::Base

  include CsvSerialize::InstanceMethods
  CsvColumns = %w[number description part.number part.description location.image location.x1 location.y1 location.x2 location.y2]

  belongs_to :protocol
  belongs_to :part
  has_one :location, :as => :locatable, :dependent => :destroy
  accepts_nested_attributes_for :location, :reject_if => lambda { |o| o[:x1].nil? ||
                                                                      o[:y1].nil? ||
                                                                      o[:x2].nil? ||
                                                                      o[:y2].nil? }, :allow_destroy => true

  validates :number, :presence => true
#  validates :part, :presence => true

  scope :sort_natural, order("LPAD(number, 5, '0') ASC")

  def pn
    self.part.try(:number)
  end

  #
  # TODO:
  # Remove "orphan" part numbers
  def pn=(n)
    self.part_id = Part.find_or_create_by_number(:number => n).id
  end
end
