require 'file_size_validator'
class Image < ActiveRecord::Base
  # # # # # Includes / Extends          # # # # #
  include CsvSerialize::InstanceMethods

  # # # # # Constants                   # # # # #
  CsvColumns = %w[]

  # # # # # Instance Variables          # # # # #
  # # # # # Callbacks                   # # # # #
  before_validation :update_checksum

  # # # # # Attr_accessible / protected # # # # #
  # # # # # Associations / Delegates    # # # # #
  mount_uploader :file, ImageUploader
  has_many :image_assignments, dependent: :destroy
  has_many :protocols, through: :image_assignments, source: :imageable, source_type: 'Protocol'
  has_many :zones, through: :image_assignments, source: :imageable, source_type: 'Zone'
  has_many :locations, dependent: :destroy
  accepts_nested_attributes_for :locations, allow_destroy: true, reject_if: ->(o){ o[:x1].nil? ||
                                                                                   o[:y1].nil? ||
                                                                                   o[:x2].nil? ||
                                                                                   o[:y2].nil? }

  # # # # # Scopes                      # # # # #

  # # # # # Validations                 # # # # #
  validates :file, file_size: { maximum: 5.megabytes.to_i }
  validates :checksum, presence: true, uniqueness: true
  # TODO: Validate Uniqueness on to_s

  # # # # # Public Methods              # # # # #
  def to_s
    File.basename file_url, '.*'
  end

  def extname
    File.extname(file_url).gsub('.', '')
  end

  def to_param
    "#{id}-#{to_s.parameterize}"
  end

  def self.checksum(url)
    Digest::MD5.hexdigest File.read(url)
  end

  def file_size
    if file.size > 1.megabyte
      "#{file.size / 1.megabyte} MB"
    else
      "#{file.size / 1.kilobyte} kB"
    end
  end

  def self.id_from_filename(filename)
    Hash[*self.all.map { |i| [File.basename(i.file_url), i.id] }.flatten][filename]
  end

  # # # # # Private Methods             # # # # #
  private
  def update_checksum
    self.checksum = Image.checksum "public#{file.to_s}"
  end
end
