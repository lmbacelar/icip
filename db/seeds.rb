# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
puts 'Start seeding ...'
# Loading Aircrafts
puts 'Importing Aircrafts from csv ...'
Aircraft.from_csv 'app/assets/seeds/aircrafts.csv'
# Loading Configurations / Zones
Aircraft.all.each do |a|
  puts "Importing configurations from csv for #{a.registration} ..."
  a.association_from_csv :configurations, 'app/assets/seeds/configurations.csv'
  a.configurations.each do |c|
    puts "Importing zones from csv for #{a.registration}, configuration #{c.number} ..."
    c.association_from_csv :zones, 'app/assets/seeds/zones.csv'
  end
end
#Loading Images on Zones
Zone.all.each do |z|
  puts "Importing images from csv for #{z.configuration.aircraft.registration}, configuration #{z.configuration}, zone #{z.name} ..."
  z.images_from_csv "app/assets/seeds/A330_TOE-TOG_#{z.name}.csv"
end
puts 'Done seeding ...'
