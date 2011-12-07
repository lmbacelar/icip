class Item < ActiveRecord::Base

  include CsvSerialize::InstanceMethods
  CsvColumns = %w[name part.number part.kind part.description location.name location.image.name]

  attr_accessible :name, :kind, :part_number, :part_id, :image_location, :location

  belongs_to :zone
  belongs_to :part
  has_one :location_assignment, :as => :locatable, :dependent => :destroy
  has_one :location, :through => :location_assignment
  has_one :image, :through => :location

  validates :name, :presence => true, :uniqueness => { :scope => :zone_id }
  validates :part, :presence => true

  scope :sort_natural, joins(:part).order("parts.kind, LPAD(SUBSTRING(name from '[0-9]+'),5, '0'), SUBSTRING(name from '[^0-9]+')")
  scope :locatable, joins(:location)

  def self.on_image(image_id)
    locatable.joins(:image).where("images.id = ?", image_id)
  end
  def self.at_position(x,y)
    locatable.where("locations.x1 <= ? AND locations.x2 >= ? AND locations.y1 <= ? AND locations.y2 >= ?",
                    x, x, y, y)
  end

  def part_number
    part.try(:number)
  end
  def part_number=(number)
    self.part = Part.find_by_number(number) if number.present?
  end

  def image_location
    "#{location.name}, on image ##{location.image_id} (#{File.basename(location.image.file_url)})" if location
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
end
