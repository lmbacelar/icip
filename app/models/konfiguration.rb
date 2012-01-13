class Konfiguration < ActiveRecord::Base
  # # # # # Includes / Extends          # # # # #
  include CsvImport::InstanceMethods

  # # # # # Constants                   # # # # #
  CsvColumns = %w[number description]

  # # # # # Instance Variables          # # # # #
  # # # # # Callbacks                   # # # # #
  # # # # # Attr_accessible / protected # # # # #
  attr_accessible :number, :description, :zones_attributes

  # # # # # Associations / Delegates    # # # # #
  belongs_to :aircraft
  has_many  :zones, dependent: :destroy
  accepts_nested_attributes_for :zones, allow_destroy: true, reject_if: ->(z){ z[:name].blank? }

  # # # # # Scopes                      # # # # #
  scope :newest, order('number DESC')
  scope :oldest, order('number ASC')

  # # # # # Validations                 # # # # #
  validates :number, presence: true, uniqueness: {scope: :aircraft_id}
  validates :description, presence: true, uniqueness: {scope: :aircraft_id}

  # # # # # Public Methods              # # # # #
  def to_s
    "##{number}"
  end

  def to_param
    "#{id}-no-#{number}"
  end

  def self.current
    newest.first
  end

  def current?
    self == self.aircraft.konfigurations.current
  end

  def self.obsolete
    newest.slice(1, newest.count-1)
  end

  def obsolete?
    !(new_record? || current?)
  end

  # # # # # Private Methods             # # # # #
  private
end
