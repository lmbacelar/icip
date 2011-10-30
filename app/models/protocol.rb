class Protocol < ActiveRecord::Base
  attr_accessible :revnum, :notes, :author, :images_attributes, :images_attributes, :checkpoints_attributes

  belongs_to :part
  has_many :image_assignments, :as => :imageable, :dependent => :destroy
  has_many :images, :through => :image_assignments, :dependent => :destroy
  accepts_nested_attributes_for :images, :allow_destroy => true, :reject_if => lambda { |i| i[:file].blank? }
  has_many :checkpoints, :as => :checkpointable, :dependent => :destroy
  accepts_nested_attributes_for :checkpoints, :allow_destroy => true,
                                              :reject_if => lambda { |c|  c[:number].blank? ||
                                                                          c[:description].blank? } # ||
  #                                                                       c[:pn].blank? }

  validates :revnum, :uniqueness => { :scope => :part_id}

  scope :newest, order('revnum DESC')
  scope :oldest, order('revnum ASC')

  def self.current
    newest.first
  end
  def current?
    self == self.part.protocols.current
  end
  def self.obsolete
    newest.slice(1, newest.count-1)
  end
  def obsolete?
    !(new_record? || current?)
  end

  def to_s
    "Rev. #{revnum} by #{author} on #{I18n.l(created_at, :format => :short_date)}"
  end
end
