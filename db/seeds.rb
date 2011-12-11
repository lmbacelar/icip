# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
puts 'START Seeding ...'
puts 'CREATING Roles ...'
[:admin, :engineer, :technician].each do |r|
  Role.create :name => r
end
puts 'CREATING Users ...'
User.create(:email => 'admin@icip.com',
            :tap_number => '000000',
            :name => 'Administrator',
            :password => 'admin',
            :password_confirmation => 'admin').roles << Role.find_by_name(:admin)
User.create(:email => 'engineer@icip.com',
            :tap_number => '000001',
            :name => 'Engineer',
            :password => 'engineer',
            :password_confirmation => 'engineer').roles << Role.find_by_name(:engineer)
User.create(:email => 'technician@icip.com',
            :tap_number => '000002',
            :name => 'Technician',
            :password => 'technician',
            :password_confirmation => 'technician').roles << Role.find_by_name(:technician)
# Loading Aircrafts
puts 'IMPORTING Aircrafts from csv ...'
Aircraft.from_csv 'db/seeds/aircrafts.csv'
# Loading Configurations / Zones / Images
Aircraft.all.each do |a|
  puts "IMPORTING Configurations from csv for #{a.registration} ..."
  a.association_from_csv :konfigurations, 'db/seeds/configurations.csv'
  a.konfigurations.each do |k|
    puts "IMPORTING Zones from csv for #{a.registration}, Configuration #{k.number} ..."
    k.association_from_csv :zones, 'db/seeds/zones.csv'
    k.zones.each do |z|
      puts "IMPORTING Images from csv for #{a.registration}, Configuration #{k.number}, zone #{z.name} ..."
      z.images_from_csv "db/seeds/#{a.registration}.#{z.name}.images.csv"
      z.images.each do |i|
        if i.locations.empty?
          puts "IMPORTING Locations from csv for Image '#{File.basename(i.file_url, '.*')} ..."
          i.association_from_csv :locations, "db/seeds/#{File.basename(i.file_url, '.*')}.locations.csv"
        else
          puts "SKIPPING Locations for Image '#{File.basename(i.file_url, '.*')}. Already loaded ..."
        end
      end
      puts "IMPORTING Items, Parts and associating Locations for #{a.registration}, Configuration #{k.number}, Zone #{z.name} ..."
      z.items_from_csv "db/seeds/#{a.registration}.#{z.name}.items.csv"
    end
  end
end

Part.all.each do |part|
  checkpoints_csv = "db/seeds/#{part.number}.checkpoints.csv"
  images_csv = "db/seeds/#{part.number}.images.csv"
  if File.exist?(checkpoints_csv) || File.exist?(images_csv)
    p = part.protocols.create(:revnum => 0, :author => 'Vera Martinho')
    if File.exist? checkpoints_csv
      puts "IMPORTING Checkpoints for P/N #{part.number} Protocol Rev.#{p.revnum} ..."
      p.checkpoints_from_csv checkpoints_csv
    end
    if File.exist? images_csv
      puts "IMPORTING Images for P/N #{part.number} Protocol Rev.#{p.revnum} ..."
      p.images_from_csv images_csv
      p.images.each do |i|
        if i.locations.empty?
          puts "IMPORTING Locations from csv for Image '#{File.basename(i.file_url, '.*')} ..."
          i.association_from_csv :locations, "db/seeds/#{File.basename(i.file_url, '.*')}.locations.csv"
        else
          puts "SKIPPING Locations for Image '#{File.basename(i.file_url, '.*')}. Already loaded ..."
        end
      end
    end
  end
end

puts 'DONE Seeding ...'
