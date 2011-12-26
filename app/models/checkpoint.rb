class Checkpoint < ActiveRecord::Base

  include CsvSerialize::InstanceMethods
  CsvColumns = %w[number description part.number part.kind part.description]

  belongs_to :protocol
  belongs_to :part
  has_one :location_assignment, as: :locatable, dependent: :destroy
  has_one :location, through: :location_assignment
  has_one :image, through: :location
  has_many :tascs, dependent: :destroy

  validates :number, presence: true
  validates :part, presence: true

  scope :sort_natural, order("LPAD(SUBSTRING(number from '[0-9]+'),5, '0'), COALESCE(SUBSTRING(number from '[^0-9]+'), '0')")

  def to_s() "#{number} - #{description}" end

  # TODO:
  # Remove "orphan" part numbers on setter
  def pn() self.part.try(:number) end
  def pn=(n) self.part_id = Part.find_or_create_by_number(number: n).id end
end
