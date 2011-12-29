class Checkpoint < ActiveRecord::Base
  # # # # # Includes / Extends          # # # # #
  include CsvSerialize::InstanceMethods

  # # # # # Constants                   # # # # #
  CsvColumns = %w[number description part.number part.kind part.description]

  # # # # # Instance Variables          # # # # #

  # # # # # Callbacks                   # # # # #

  # # # # # Attr_accessible / protected # # # # #

  # # # # # Associations / Delegates    # # # # #
    #
    # TODO:
    # 1. Replace number by location.number (add association)
    # 2. Replace description by part.description ???
    #    This might not be true. Checkpoint description might be different from Part description.
  belongs_to :checkpointable, polymorphic: true
  belongs_to :part
  has_one :location_assignment, as: :locatable, dependent: :destroy
  has_one :location, through: :location_assignment
  has_one :image, through: :location
  has_many :tascs, dependent: :destroy

  # # # # # Scopes                      # # # # #
  scope :sort_natural, order("LPAD(SUBSTRING(number from '[0-9]+'),5, '0'), COALESCE(SUBSTRING(number from '[^0-9]+'), '0')")

  # # # # # Validations                 # # # # #
  validates :number, presence: true
  validates :part, presence: true

  # # # # # Public Methods              # # # # #
  def to_s
    "#{number} - #{description}"
  end

  # TODO:
  # Remove "orphan" part numbers on setter
  def pn
    part.try(:number)
  end

  def pn=(n)
    self.part_id = Part.find_or_create_by_number(number: n).id
  end
  # # # # # Private Methods             # # # # #
end
