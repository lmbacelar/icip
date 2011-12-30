class Checkpoint < ActiveRecord::Base
  # # # # # Includes / Extends          # # # # #
  include CsvSerialize::InstanceMethods

  # # # # # Constants                   # # # # #
  CsvColumns = %w[location.name location.image part.number part.kind part.description]

  # # # # # Instance Variables          # # # # #

  # # # # # Callbacks                   # # # # #

  # # # # # Attr_accessible / protected # # # # #

  # # # # # Associations / Delegates    # # # # #
    #
    # TODO:
    # 1. Replace number by location.number (add association)
    # 2. Replace description by part.description ???
    #    This might not be true. Checkpoint description might be different from Part description.
  belongs_to :protocol
  belongs_to :part
  has_one :location_assignment, as: :locatable, dependent: :destroy
  has_one :location, through: :location_assignment
  has_one :image, through: :location
  has_many :tascs, dependent: :destroy

  # # # # # Scopes                      # # # # #
  scope :sort_natural, joins(:location).order("LPAD(SUBSTRING(locations.name from '[0-9]+'),5, '0'), COALESCE(SUBSTRING(locations.name from '[^0-9]+'), '0')")

  # # # # # Validations                 # # # # #
  validates :location, presence: true
  validates :part, presence: true

  # # # # # Public Methods              # # # # #
  def to_s
    "#{part.number}"
  end

  # TODO:
  # Remove "orphan" part numbers on setter
  def image_location
    "#{location.name}, on image ##{location.image_id} (#{image})" if location
  end

  def image_location=(args)
    unless args.nil?
      args=args.split(',')
      if args.size > 1
        self.location = Location.find_by_image_id_and_name(args[1][/(?<=#)[\d]*/], args[0])
      else
        self.location = nil
      end
    end
  end

  def part_number
    part.try(:number)
  end

  def part_number=(number)
    self.part = Part.find_by_number(number) if number.present?
  end

  # # # # # Private Methods             # # # # #
end
