class User < ActiveRecord::Base

  VALID_TAP_NUMBER_REGEXP = /^[\d]{5,6}$/
  # VALID_EMAIL_REGEXP defined in initializers/constants.rb

  has_secure_password

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

end
