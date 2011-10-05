# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
puts 'Start seeding ...'
# Loading Aircrafts
puts 'Importing Aircrafts from csv ...'
Aircraft.from_csv 'app/assets/seeds/aircrafts.csv'
# Loading Configurations / Zones / Images
Aircraft.all.each do |a|
  puts "Importing configurations from csv for #{a.registration} ..."
  a.association_from_csv :konfigurations, 'app/assets/seeds/configurations.csv'
  a.konfigurations.each do |k|
    puts "Importing zones from csv for #{a.registration}, configuration #{k.number} ..."
    k.association_from_csv :zones, 'app/assets/seeds/zones.csv'
    k.zones.each do |z|
      puts "Importing images from csv for #{a.registration}, configuration #{k.number}, zone #{z.name} ..."
      z.images_from_csv "app/assets/seeds/A330_TOE-TOG_#{z.name}.csv"
      puts "Importing items and parts for #{a.registration}, configuration #{k.number}, zone #{z.name} ..."
      z.items_from_csv "app/assets/seeds/A330_TOE-TOG_#{z.name}_items.csv"
    end
  end
end

puts 'Done seeding ...'
