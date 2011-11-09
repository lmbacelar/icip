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
      z.images_from_csv "app/assets/seeds/#{a.registration}.#{z.name}.images.csv"
      puts "Importing items, parts and locations for #{a.registration}, configuration #{k.number}, zone #{z.name} ..."
      z.items_from_csv "app/assets/seeds/#{a.registration}.#{z.name}.items.csv"
    end
  end
end

Part.all.each do |part|
  p=part.protocols.build :revnum => 0
  # if File.exist? "app/assets/seeds/#{part.number}.checkpoints.csv"
  #   p.checkpoints_from_csv "app/assets/seeds/#{part.number}.checkpoints.csv"
  # end
  if File.exist? "app/assets/seeds/#{part.number}.images.csv"
    puts "Importing images for P/N #{part.number} default protocol ..."
    p.images_from_csv "app/assets/seeds/#{part.number}.images.csv"
  end
  p.save if p.images.any? || p.checkpoints.any?
end
puts 'Done seeding ...'
