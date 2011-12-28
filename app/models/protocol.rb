class Protocol < ActiveRecord::Base
  # # # # # Includes / Extends          # # # # #
  include CsvSerialize::InstanceMethods

  # # # # # Constants                   # # # # #
  # # # # # Instance Variables          # # # # #
  # # # # # Callbacks                   # # # # #
  before_validation :set_revnum

  # # # # # Attr_accessible / protected # # # # #
  attr_accessible :revnum, :notes, :author_id, :image_ids, :checkpoints_attributes

  # # # # # Associations / Delegates    # # # # #
  belongs_to :part
  belongs_to :author, class_name: 'User'
  has_many :image_assignments, as: :imageable, dependent: :destroy
  has_many :images, through: :image_assignments, dependent: :destroy
  has_many :checkpoints, as: :checkpointable, dependent: :destroy
  accepts_nested_attributes_for :checkpoints, allow_destroy: true,
                                              reject_if: ->(c){ c[:number].blank? ||
                                                                c[:description].blank? }

  # # # # # Scopes                      # # # # #
  scope :newest, order('revnum DESC')
  scope :oldest, order('revnum ASC')

  # # # # # Validations                 # # # # #
  validates :revnum, uniqueness: { scope: :part_id}
  validates :author, presence: true

  # # # # # Public Methods              # # # # #
  def to_s
    "Rev. #{revnum}"
  end

  def to_param
    "#{id}-#{to_s.parameterize}"
  end

  def current?
    self == self.part.protocols.current
  end

  def obsolete?
    !(new_record? || current?)
  end

  def state
    if current?
      :current
    elsif obsolete?
      :obsolete
    else
      :new_record
    end
  end

  def self.current
    newest.first
  end

  def self.obsolete
    newest.slice(1, newest.count-1)
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
          csv << [c.number, c.description,
                  c.part.try(:number), c.part.try(:kind), c.part.try(:description)]
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
          checkpoints.create(number: line[0], description: line[1],
                             part_id: Part.find_or_create_by_number(number: line[2],
                                                                    kind: line[3],
                                                                    description: line[4]).id)
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

  # # # # # Private Methods             # # # # #
  private
  def set_revnum
    unless self.revnum.present?
      self.revnum = 1 + ( part.protocols.maximum(:revnum) || -1 )
    end
  end
end
