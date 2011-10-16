class Zone < ActiveRecord::Base

  include CsvSerialize::InstanceMethods
  CsvColumns = %w[name description inspection_interval]

  attr_accessible :name, :description, :inspection_interval, :images_attributes, :parts_attributes, :items_attributes

  belongs_to :konfiguration
  has_many  :items, :dependent => :destroy
  has_many :parts, :through => :items
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

  def items_to_csv(fname)
    begin
      CSV.open(fname, 'w') do |csv|
        # header
        csv << Item::CsvColumns
        # iterate children
        items.each do |i|
          csv << [i.name, i.kind,
                  i.part.try(:number), i.part.try(:description),
                  File.basename(i.location.try(:image).try(:file_url)),
                  i.location.try(:x1), i.location.try(:y1),
                  i.location.try(:x2), i.location.try(:y2)]
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
          url = File.join(Rails.root, File.join(File.dirname(fname), line[4]))
          items.create(:name => line[0], :kind => line[1],
                       :part_id => Part.find_or_create_by_number(:number => line[2], :description => line[3]).id,
                       :location => Location.create(:x1=>line[5], :y1 => line[6], :x2 => line[7], :y2 => line[8],
                                                    :image => Image.find_or_create_by_checksum(:file => File.open(url), :checksum => Image.checksum(url))))
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
