require 'csv'

module CsvSerialize
  module ClassMethods
###    def to_csv(fname)
###      begin
###        CSV.open(fname, 'w') do |csv|
###          # header
###          csv << self::CsvColumns
###          # export data
###          all.each do |a|
###            line = []
###            self::CsvColumns.each { |d| line << a[d] }
###            csv << line
###          end
###        end
###      rescue Errno::EISDIR
###        puts "ERROR: '#{fname}' is a directory. #{name.pluralize} not exported."
###      rescue Errno::EACCES
###        puts "ERROR: Permission denied on '#{fname}'. #{name.pluralize} not exported."
###      end
###    end
###
###    def from_csv(fname)
###      begin
###        lines = CSV.read(fname)
###        header = lines.shift
###        # check header
###        if header == self::CsvColumns
###          # import data
###          lines.each { |line| create(Hash[*header.zip(line).flatten]) }
###        else
###          puts "ERROR: Expecting #{self::CsvColumns.join(',')} on '#{fname}'. Skipping import of #{name.downcase.pluralize}."
###          false
###        end
###      rescue Errno::EISDIR
###        puts "ERROR: '#{fname}' is a directory. #{name.pluralize} not imported."
###      rescue Errno::EACCES
###        puts "ERROR: Permission denied on '#{fname}'. #{name.pluralize} not imported."
###      rescue Errno::ENOENT
###        puts "ERROR: '#{fname}' not found. #{name.pluralize} not imported."
###      end
###    end
  end # ClassMethods

  module InstanceMethods
###    def association_to_csv(assoc_sym, fname)
###      csv_data = association(assoc_sym).klass::CsvColumns
###      csv_data.collect! { |d| d.to_s }
###      begin
###        CSV.open(fname, 'w') do |csv|
###          # header
###          csv << csv_data
###          # iterate children
###          association(assoc_sym).load_target.collect do |c|
###            line = []
###            csv_data.each { |d| line << c[d] }
###            # export data
###            csv << line
###          end
###        end
###      rescue Errno::EISDIR
###        puts "ERROR: '#{fname}' is a directory. #{assoc_sym.to_s.titleize.pluralize} not exported."
###      rescue Errno::EACCES
###        puts "ERROR: Permission denied on '#{fname}'. #{assoc_sym.to_s.titleize.pluralize} not exported."
###      end
###    end
###
###    def association_from_csv(assoc_sym, fname)
###      csv_data = association(assoc_sym).klass::CsvColumns
###      csv_data.collect! { |d| d.to_s }
###      begin
###        lines = CSV.read(fname)
###        header = lines.shift
###        # check header
###        if header == csv_data
###          # import data
###          lines.each { |line| association(assoc_sym).create(Hash[*header.zip(line).flatten]) }
###        else
###          puts "ERROR: Expecting #{csv_data.join(',')} on '#{fname}'. Skipping import of #{assoc_sym.to_s.pluralize}."
###          false
###        end
###      rescue Errno::EISDIR
###        puts "ERROR: '#{fname}' is a directory. #{assoc_sym.to_s.titleize.pluralize} not imported."
###      rescue Errno::EACCES
###        puts "ERROR: Permission denied on '#{fname}'. #{assoc_sym.to_s.titleize.pluralize} not imported."
###      rescue Errno::ENOENT
###        puts "ERROR: '#{fname}' not found. #{assoc_sym.to_s.titleize.pluralize} not imported."
###      end
###    end
###
###    ##
###    # WARNING: Images with the same filename will be destroyed.
###    #          This could be improved.
###    def images_to_csv(fname)
###      begin
###        CSV.open(fname, 'w') do |csv|
###          csv << ['file_url']
###          images.collect do |i|
###            # copy file to csv path
###            FileUtils.cp File.join(Rails.public_path,i.file_url), File.join(Rails.root,File.join(File.dirname(fname), File.basename(i.file_url)))
###            # write filename
###            csv << [File.basename(i.file_url)]
###          end
###        end
###      rescue Errno::EISDIR
###        puts "ERROR: '#{fname}' is a directory. #{assoc_sym.to_s.titleize.pluralize} not exported."
###      rescue Errno::EACCES
###        puts "ERROR: Permission denied on '#{fname}'. #{assoc_sym.to_s.titleize.pluralize} not exported."
###      end
###    end
###
###    def images_from_csv(fname)
###      begin
###        is = CSV.read(fname)
###        i = is.shift
###        if i.count == 1 && i[0] == 'file_url'
###          is.each do |i|
###            url = File.join(Rails.root, File.join(File.dirname(fname), i))
###            images << Image.find_or_create_by_checksum(file: File.open(url), checksum: Image.checksum(url))
###          end
###        else
###          puts "ERROR: Invalid format of #{fname}. Should be 'file_url'. Images not imported."
###          false
###        end
###      rescue Errno::EISDIR
###        puts "ERROR: '#{fname}' is a directory. Images not imported."
###      rescue Errno::EACCES
###        puts "ERROR: Permission denied on '#{fname}'. Images not imported."
###      rescue Errno::ENOENT
###        puts "ERROR: '#{fname}' not found. Images not imported."
###      end
###    end
  end # InstanceMethods
end


