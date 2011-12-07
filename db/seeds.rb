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
      z.images.each do |i|
        if i.locations.empty?
          puts "Importing locations from csv for image '#{File.basename(i.file_url, '.*')} ..."
          i.association_from_csv :locations, "app/assets/seeds/#{File.basename(i.file_url, '.*')}.locations.csv"
        else
          puts "Locations already loaded for image '#{File.basename(i.file_url, '.*')}. Skipping ..."
        end
      end
      puts "Importing items, parts and associating locations for #{a.registration}, configuration #{k.number}, zone #{z.name} ..."
      z.items_from_csv "app/assets/seeds/#{a.registration}.#{z.name}.items.csv"
    end
  end
end

Part.all.each do |part|
  checkpoints_csv = "app/assets/seeds/#{part.number}.checkpoints.csv"
  images_csv = "app/assets/seeds/#{part.number}.images.csv"
  if File.exist?(checkpoints_csv) || File.exist?(images_csv)
    p = part.protocols.create(:revnum => 0, :author => 'Vera Martinho')
    if File.exist? checkpoints_csv
      puts "Importing checkpoints for P/N #{part.number} protocol rev.#{p.revnum} ..."
      p.checkpoints_from_csv checkpoints_csv
    end
    if File.exist? images_csv
      puts "Importing images for P/N #{part.number} protocol rev.#{p.revnum} ..."
      p.images_from_csv images_csv
      p.images.each do |i|
        if i.locations.empty?
          puts "Importing locations from csv for image '#{File.basename(i.file_url, '.*')} ..."
          i.association_from_csv :locations, "app/assets/seeds/#{File.basename(i.file_url, '.*')}.locations.csv"
        else
          puts "Locations already loaded for image '#{File.basename(i.file_url, '.*')}. Skipping ..."
        end
      end
    end
  end
end

puts 'Done seeding ...'
