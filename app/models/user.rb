class User < ActiveRecord::Base
  # # # # # Includes / Extends          # # # # #
  # # # # # Constants                   # # # # #
  VALID_TAP_NUMBER_REGEXP = /^[\d]{5,6}$/
  # VALID_EMAIL_REGEXP defined in initializers/constants.rb
  # # # # # Instance Variables          # # # # #
  # # # # # Callbacks                   # # # # #
  # # # # # Attr_accessible / protected # # # # #
  # # # # # Associations / Delegates    # # # # #
  has_many :memberships, dependent: :destroy
  has_many :roles, through: :memberships
  has_many :inspections, dependent: :destroy, foreign_key: :technician_id

  # # # # # Scopes                      # # # # #
  # # # # # Validations                 # # # # #
  validates  :email,  presence: true,
                      uniqueness: { case_sensitive: false },
                      length: { within: 5..50 },
                      format: { with: VALID_EMAIL_REGEXP }
  validates :tap_number, presence: true,
                         uniqueness: { case_sensitive: false },
                         length: { within: 5..6 },
                         format: { with: VALID_TAP_NUMBER_REGEXP }
  validates :password, confirmation: true,
                       length: { within: 3..20 },
                       presence: true

  # # # # # Public Methods              # # # # #
  has_secure_password

  def to_s
    tap_number
  end

  def to_param
    "#{id}-#{tap_number.parameterize}"
  end

  def role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end

  def role_list
    roles.collect {|r| r.name}.join(', ')
  end

  def short_email
    email[/(^.*)@/,1]
  end

  # # # # # Private Methods             # # # # #
end
