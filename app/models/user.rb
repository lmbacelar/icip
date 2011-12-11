class User < ActiveRecord::Base

  VALID_TAP_NUMBER_REGEXP = /^[\d]{5,6}$/
  # VALID_EMAIL_REGEXP defined in initializers/constants.rb

  has_secure_password

  has_many :memberships, :dependent => :destroy
  has_many :roles, :through => :memberships

  validates  :email,  :presence => true,
                      :uniqueness => { :case_sensitive => false },
                      :length => { :within => 5..50 },
                      :format => { :with => VALID_EMAIL_REGEXP }
  validates :tap_number, :presence => true,
                         :uniqueness => { :case_sensitive => false },
                         :length => { :within => 5..6 },
                         :format => { :with => VALID_TAP_NUMBER_REGEXP }
  validates :password,  :confirmation => true,
                        :length => { :within => 3..20 },
                        :presence => true

  def role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end

  def role_list
    roles.collect {|r| r.name}.join(', ')
  end

  def short_email
    email[/(^.*)@/,1]
  end
end
