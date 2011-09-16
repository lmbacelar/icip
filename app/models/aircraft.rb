class Aircraft < ActiveRecord::Base

  attr_accessible :registration, :manufacturer, :model, :configurations_attributes

  validates :registration, :presence => true, :uniqueness => true

  has_many  :configurations, :dependent => :destroy
  accepts_nested_attributes_for :configurations, :reject_if => lambda { |c| c[:number].blank? }, :allow_destroy => true

  def self.csv_data
    %w[registration manufacturer model]
  end

  #
  # TODO:
  # Share this code for all classes that require csv import / export
  #
  require 'csv'

  def self.to_csv(fname)
    CSV.open(fname, 'w') do |csv|
      # header
      csv << self.csv_data
      # export data
      self.all.each do |a|
        line = []
        self.csv_data.each { |d| line << a[d] }
        csv << line
      end
    end
  end

  def self.from_csv(fname)
    lines = CSV.read(fname)
    header = lines.shift
    # check header
    if header == self.csv_data
      # import data
      lines.each { |line| create(Hash[*header.zip(line).flatten]) }
    else
      puts "ERROR: Expecting #{list.join(',')} on #{fname}. Skipping import of #{self.name.downcase.pluralize}."
    end
  end
end
