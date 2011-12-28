class Zone < ActiveRecord::Base
  # # # # # Includes / Extends          # # # # #
  include CsvSerialize::InstanceMethods

  # # # # # Constants                   # # # # #
  CsvColumns = %w[name description inspection_interval]

  # # # # # Instance Variables          # # # # #
  # # # # # Callbacks                   # # # # #
  # # # # # Attr_accessible / protected # # # # #
  attr_accessible :name, :description, :inspection_interval, :images_attributes, :parts_attributes, :items_attributes

  # # # # # Associations / Delegates    # # # # #
  belongs_to :konfiguration
  has_many  :items, dependent: :destroy
  has_many :parts, through: :items
  has_many :inspections, dependent: :destroy
  has_many :image_assignments, as: :imageable, dependent: :destroy
  has_many :images, through: :image_assignments, dependent: :destroy
  has_many :locations, through: :images
  accepts_nested_attributes_for :items, allow_destroy: true, reject_if: ->(i){ i[:name].blank? }
  accepts_nested_attributes_for :images, allow_destroy: true, reject_if: ->(i){ i[:file].blank? }

  # # # # # Scopes                      # # # # #
  # # # # # Validations                 # # # # #
  validates :name, presence: true, uniqueness: {scope: :konfiguration_id}
  validates :inspection_interval, presence: true, numericality: { only_integer: true,
                                                                  greater_than: 0,
                                                                  less_than: 366 }

  # # # # # Public Methods              # # # # #
  def schedule_inspection
    # Will not schedule if there is already an
    # unassigned or assigned inspection for this zone.
    # Will schedule if there are no inspections or if
    # Inspection is overdue according to inspection_interval
    # and last inspection execution_date
    if inspections.unassigned.all.empty? && inspections.assigned.all.empty?
      if inspections.all.empty? || inspections.maximum(:execution_date) < Time.now - inspection_interval.days
        inspections.create
      end
    end
  end

  def self.schedule_inspections
    self.all.each { |z| z.schedule_inspection }
  end

  def items_to_csv(fname)
    begin
      CSV.open(fname, 'w') do |csv|
        # header
        csv << Item::CsvColumns
        # iterate children
        items.each do |i|
          csv << [i.name, i.part.try(:number), i.part.try(:kind), i.part.try(:description)]
        end
      end
    rescue Errno::EISDIR
      puts "ERROR: '#{fname}' is a directory. Items not exported."
    rescue Errno::EACCES
      puts "ERROR: Permission denied on '#{fname}'. Items not exported."
    end
  end

  def items_from_csv(fname)
    begin
      lines = CSV.read(fname)
      header = lines.shift
      # check header
      if header == Item::CsvColumns
        # import data
        lines.each do |line|
          i = items.create(name: line[0],
                           part_id: Part.find_or_create_by_number(number: line[1],
                                                                  kind: line[2],
                                                                  description: line[3]).id)
          # Associate location when possible
          unless line[5].nil?
            url = File.join(Rails.root, File.join(File.dirname(fname), line[5]))
            i.location = Location.find_by_name_and_image_id(
                                    line[4],
                                    Image.find_or_create_by_checksum(
                                      file: File.open(url), checksum: Image.checksum(url)).id)
          end
        end
      else
        puts "ERROR: Expecting ''#{Item::CsvColumns.join(',')}' on '#{fname}'. Skipping import of Items."
        false
      end
    rescue Errno::EISDIR
      puts "ERROR: '#{fname}' is a directory. Items not imported."
    rescue Errno::EACCES
      puts "ERROR: Permission denied on '#{fname}'. Items not imported."
    rescue Errno::ENOENT
      puts "ERROR: '#{fname}' not found. Items not imported."
    end
  end

  # # # # # Private Methods             # # # # #
  private
end
