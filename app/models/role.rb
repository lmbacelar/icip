class Role < ActiveRecord::Base
  # # # # # Includes / Extends          # # # # #
  # # # # # Constants                   # # # # #
  # # # # # Instance Variables          # # # # #
  # # # # # Callbacks                   # # # # #
  # # # # # Attr_accessible / protected # # # # #
  # # # # # Associations / Delegates    # # # # #
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  # # # # # Scopes                      # # # # #
  # # # # # Validations                 # # # # #
  validates :name, presence: true, uniqueness: true, length: { maximum: 10 }

  # # # # # Public Methods              # # # # #
  def to_s
    name
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

  # # # # # Private Methods             # # # # #
end
