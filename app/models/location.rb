class Location < ActiveRecord::Base
  # # # # # Includes / Extends          # # # # #
  include CsvSerialize::InstanceMethods

  # # # # # Constants                   # # # # #
  CsvColumns = %w[name x1 y1 x2 y2]

  # # # # # Instance Variables          # # # # #
  # # # # # Callbacks                   # # # # #
  # # # # # Attr_accessible / protected # # # # #
  # # # # # Associations / Delegates    # # # # #
  belongs_to :image

  # # # # # Scopes                      # # # # #
  scope :sort_natural, order("LPAD(SUBSTRING(name from '[0-9]+'),5, '0'), SUBSTRING(name from '[^0-9]+')")

  # # # # # Validations                 # # # # #
  validates :name, presence: true, uniqueness: {scope: :image_id}
  validates :image, presence: true
  validates :x1, inclusion: { in: 0..1.0/0, message: 'should be positive' }
  validates :y1, inclusion: { in: 0..1.0/0, message: 'should be positive' }
  validates :x2, inclusion: { in: 0..1.0/0, message: 'should be positive' }
  validates :y2, inclusion: { in: 0..1.0/0, message: 'should be positive' }

  # # # # # Public Methods              # # # # #
  def to_s
    name
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

  def image_id
    image.try(:id)
  end

  # # # # # Private Methods             # # # # #
  private

end
