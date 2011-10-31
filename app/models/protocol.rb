class Protocol < ActiveRecord::Base

  include CsvSerialize::InstanceMethods

  attr_accessible :revnum, :notes, :author, :images_attributes, :images_attributes, :checkpoints_attributes

  belongs_to :part
  has_many :image_assignments, :as => :imageable, :dependent => :destroy
  has_many :images, :through => :image_assignments, :dependent => :destroy
  accepts_nested_attributes_for :images, :allow_destroy => true, :reject_if => lambda { |i| i[:file].blank? }
  has_many :checkpoints, :as => :checkpointable, :dependent => :destroy
  accepts_nested_attributes_for :checkpoints, :allow_destroy => true,
                                              :reject_if => lambda { |c|  c[:number].blank? ||
                                                                          c[:description].blank? } # ||
  #                                                                       c[:pn].blank? }

  validates :revnum, :uniqueness => { :scope => :part_id}

  scope :newest, order('revnum DESC')
  scope :oldest, order('revnum ASC')

  def self.current
    newest.first
  end
  def current?
    self == self.part.protocols.current
  end
  def self.obsolete
    newest.slice(1, newest.count-1)
  end
  def obsolete?
    !(new_record? || current?)
  end

  def to_s
    "Rev. #{revnum} by #{author} on #{I18n.l(created_at, :format => :short_date)}"
  end

  #
  # TODO:
  # Factor out this code. Duplication with Items items_to_csv. Make it model independent.
  #
  def checkpoints_to_csv(fname)
    begin
      CSV.open(fname, 'w') do |csv|
        # header
        csv << Checkpoint::CsvColumns
        # iterate children
        checkpoints.each do |c|
          image_url = c.location.try(:image).try(:file_url)
          csv << [c.number, c.description,
                  c.part.try(:number), c.part.try(:description),
                  image_url && File.basename(image_url.to_s),
                  c.location.try(:x1), c.location.try(:y1),
                  c.location.try(:x2), c.location.try(:y2)]
        end
      end
    rescue Errno::EISDIR
      puts "ERROR: '#{fname}' is a directory. Checkpoints not exported."
    rescue Errno::EACCES
      puts "ERROR: Permission denied on '#{fname}'. Checkpoints not exported."
    end
  end

  #
  # TODO:
  # Factor out this code. Duplication with Items items_from_csv. Make it model independent.
  #
  def checkpoints_from_csv(fname)
    begin
      lines = CSV.read(fname)
      header = lines.shift
      # check header
      if header == Checkpoint::CsvColumns
        # import data
        lines.each do |line|
          url = File.join(Rails.root, File.join(File.dirname(fname), line[4]))
          checkpoints.create(:number => line[0], :description => line[1],
                             :part_id => Part.find_or_create_by_number(:number => line[2], :description => line[3]).id,
                             :location => Location.create(:x1=>line[5], :y1 => line[6], :x2 => line[7], :y2 => line[8],
                                                          :image => Image.find_or_create_by_checksum(:file => File.open(url),
                                                                                                     :checksum => Image.checksum(url))))
        end
      else
        puts "ERROR: Expecting ''#{Item::CsvColumns.join(',')}' on '#{fname}'. Skipping import of Checkpoints."
        false
      end
    rescue Errno::EISDIR
      puts "ERROR: '#{fname}' is a directory. Checkpoints not imported."
    rescue Errno::EACCES
      puts "ERROR: Permission denied on '#{fname}'. Checkpoints not imported."
    rescue Errno::ENOENT
      puts "ERROR: '#{fname}' not found. Checkpoints not imported."
    end
  end
end
