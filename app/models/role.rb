class Role < ActiveRecord::Base
  has_many :memberships, :dependent => :destroy
  has_many :users, :through => :memberships

  validates :name, :presence => true, :uniqueness => true, :length => { :maximum => 10 }
end
