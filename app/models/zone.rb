class Zone < ActiveRecord::Base

  include CsvSerialize::InstanceMethods
  CsvColumns = %w[name description inspection_interval]

  attr_accessible :name, :description, :inspection_interval, :images_attributes, :parts_attributes, :items_attributes

  belongs_to :konfiguration
  has_many  :items, :dependent => :destroy
  has_many :parts, :through => :items
  has_many :inspections, :dependent => :destroy
  has_many :image_assignments, :as => :imageable, :dependent => :destroy
  has_many :images, :through => :image_assignments, :dependent => :destroy
  accepts_nested_attributes_for :items, :reject_if => lambda { |i| i[:name].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :images, :reject_if => lambda { |i| i[:file].blank? }, :allow_destroy => true

  validates :name, :presence => true, :uniqueness => {:scope => :konfiguration_id}
  validates :inspection_interval, :presence => true, :numericality => { :only_integer => true,
                                                                        :greater_than => 0,
                                                                        :less_than => 366 }

  scope :asc, order('name ASC')
  scope :desc, order('name DESC')

  def schedule_inspection
    if inspections.maximum(:execution_date).nil? ||
       (inspections.maximum(:execution_date) <= Time.now - inspection_interval.days)
      inspections.create if inspections.scheduled.empty?
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
          items.create(:name => line[0],
                       :part_id => Part.find_or_create_by_number(:number => line[1],
                                                                 :kind => line[2],
                                                                 :description => line[3]).id)
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
end
