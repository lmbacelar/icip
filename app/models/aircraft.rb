class Aircraft < ActiveRecord::Base

  # # # Includes / Extends # # # # #
  extend  CsvSerialize::ClassMethods
  include CsvSerialize::InstanceMethods

  # # #  # # Constants # # # # #
  CsvColumns = %w[registration manufacturer model]

  # # # # # Instance Variables # # # # #

  # # # # # Callbacks # # # # #

  # # # # # Attr_accessible / protected # # # # #
  attr_accessible :registration, :manufacturer, :model, :konfigurations_attributes

  # # # # # Associations # # # # #
  has_many  :konfigurations, dependent: :destroy
  has_many :zones, through: :konfigurations
  has_many :inspections, through: :zones
  has_many :tascs, through: :inspections
  accepts_nested_attributes_for :konfigurations, allow_destroy: true, reject_if: ->(c){ c[:number].blank? }

  # # # # # Scopes # # # # #

  # # # # # Validations # # # # #
  validates :registration, presence: true, uniqueness: true

  # # # # # Public Methods # # # # #
  def to_s
    registration
  end

  def to_param
    "#{id}-#{registration.parameterize}"
  end

  # # # # # Private Methods # # # # #
end
