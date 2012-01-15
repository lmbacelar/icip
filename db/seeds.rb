# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
puts 'START Seeding ...'
puts '[ CREATING   ]   Roles ...'
[:admin, :engineer, :technician].each do |r|
  Role.create name: r
end
puts '[ CREATING   ]   Users ...'
User.create(email: 'admin@tap.pt',
            tap_number: '000000',
            name: 'Administrator',
            password: 'tap',
            password_confirmation: 'tap').roles << Role.find_by_name(:admin)
User.create(email: 'engineer@tap.pt',
            tap_number: '000001',
            name: 'Engineer',
            password: 'tap',
            password_confirmation: 'tap').roles << Role.find_by_name(:engineer)
User.create(email: 'technician@tap.pt',
            tap_number: '000002',
            name: 'Technician',
            password: 'tap',
            password_confirmation: 'tap').roles << Role.find_by_name(:technician)
User.create(email: 'lbacelar@tap.pt',
            tap_number: '258756',
            name: 'Luis Bacelar',
            password: 'tap',
            password_confirmation: 'tap').roles << Role.find_by_name(:admin)
User.create(email: 'vmmartinho@tap.pt',
            tap_number: '308007',
            name: 'Vera Martinho',
            password: 'tap',
            password_confirmation: 'tap').roles << Role.find_by_name(:engineer)
User.create(email: 'toze@tap.pt',
            tap_number: '000003',
            name: 'ToZe',
            password: 'tap',
            password_confirmation: 'tap').roles << Role.find_by_name(:technician)
# Loading Aircrafts
puts '[ IMPORTING  ]   Aircrafts from csv ...'
Aircraft.from_csv 'db/seeds/aircrafts.csv'
# Loading Configurations / Zones / Images
Aircraft.all.each do |a|
  puts "[ IMPORTING  ]   Configurations from csv for #{a} ..."
  a.association_from_csv :konfigurations, 'db/seeds/configurations.csv'
  a.konfigurations.each do |k|
    puts "[ IMPORTING  ]   Zones from csv for #{a}, Configuration #{k} ..."
    k.association_from_csv :zones, 'db/seeds/zones.csv'
    k.zones.each do |z|
      puts "[ IMPORTING  ]   Images from csv for #{a}, Configuration #{k}, zone #{z} ..."
      z.images_from_csv "db/seeds/images/#{a}.#{z}.csv"
      z.images.each do |i|
        if i.locations.empty?
          puts "[ IMPORTING  ]   Locations from csv for Image '#{i} ..."
          i.association_from_csv :locations, "db/seeds/locations/#{i}.csv"
        else
          puts "[ SKIPPING   ]   Locations for Image '#{i}. Already loaded ..."
        end
      end
      puts "[ IMPORTING  ]   Items, Parts and associating Locations for #{a}, Configuration #{k}, Zone #{z} ..."
      z.items_from_csv "db/seeds/items/#{a}.#{z}.csv"
    end
  end
end

Part.all.each do |part|
  checkpoints_csv = "db/seeds/checkpoints/#{part}.csv"
  images_csv = "db/seeds/images/#{part}.csv"
  if File.exist?(images_csv) || File.exist?(checkpoints_csv)
    p = part.protocols.create(author_id: User.find_by_tap_number('308007').id)
    if File.exist? images_csv
      puts "[ IMPORTING  ]   Images for P/N #{part} Protocol #{p} ..."
      p.images_from_csv images_csv
      p.images.each do |i|
        if i.locations.empty?
          puts "[ IMPORTING  ]   Locations from csv for Image '#{i} ..."
          i.association_from_csv :locations, "db/seeds/locations/#{i}.csv"
        else
          puts "[ SKIPPING   ]   Locations for Image '#{i}. Already loaded ..."
        end
      end
    end
    if File.exist? checkpoints_csv
      puts "[ IMPORTING  ]   Checkpoints for P/N #{part} Protocol #{p} ..."
      p.checkpoints_from_csv checkpoints_csv
    end
  end
end

puts "[ SCHEDULING ]   Inspections. This should take about #{Zone.count} seconds ..."
Zone.order('zones.id DESC').schedule_inspections(1)

puts '[ UPDATING   ]   Tire indexes on Part ...'
%x[rake environment tire:import CLASS=Part FORCE=true]
puts '[ UPDATING   ]   Tire indexes on Inspection ...'
%x[rake environment tire:import CLASS=Inspection FORCE=true]
puts '[ UPDATING   ]   Tire indexes on Task ...'
%x[rake environment tire:import CLASS=Tasc FORCE=true]

puts 'DONE Seeding ...'
