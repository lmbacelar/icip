class Configuration < ActiveRecord::Base
  attr_accessible :number, :description, :zones_attributes

  validates :number, :presence => true, :uniqueness => {:scope => :aircraft_id}

  belongs_to :aircraft
  has_many  :zones, :dependent => :destroy
  accepts_nested_attributes_for :zones, :reject_if => lambda { |z| z[:name].blank? }, :allow_destroy => true

  def self.to_csv(fname)
    CSV.open(fname, 'w') do |csv|
      csv << ['number', 'description']
      self.all.each { |z| csv << [z.number, z.description] }
    end
  end

  def self.from_csv(fname)
    zs = CSV.read(fname)
    z = zs.shift
    if z[0] == 'number' && z[1] == 'description'
      zs.each { |z| create(:number => z[0], :description => z[1]) }
    else
      puts "ERROR: Expecting 'number','description' on #{fname}. Skipping import of #{self.name.downcase.pluralize}."
    end
  end
end
