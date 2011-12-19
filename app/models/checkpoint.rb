class Checkpoint < ActiveRecord::Base

  include CsvSerialize::InstanceMethods
  CsvColumns = %w[number description part.number part.kind part.description]

  belongs_to :protocol
  belongs_to :part
  has_one :location, :as => :locatable, :dependent => :destroy
  has_many :tascs, :dependent => :destroy

  validates :number, :presence => true
  validates :part, :presence => true

  scope :sort_natural, order("LPAD(SUBSTRING(number from '[0-9]+'),5, '0'), COALESCE(SUBSTRING(number from '[^0-9]+'), '0')")

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
