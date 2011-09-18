require 'csv'

module CsvSerialize
  module ClassMethods
    def to_csv(fname)
      begin
        CSV.open(fname, 'w') do |csv|
          # header
          csv << self::CsvColumns
          # export data
          all.each do |a|
            line = []
            self::CsvColumns.each { |d| line << a[d] }
            csv << line
          end
        end
      rescue Errno::EISDIR
        puts "ERROR: '#{fname}' is a directory. #{name.pluralize} not imported."
      rescue Errno::EACCES
        puts "ERROR: Permission denied on '#{fname}'. #{name.pluralize} not imported."
      end
    end

    def from_csv(fname)
      begin
        lines = CSV.read(fname)
        header = lines.shift
        # check header
        if header == self::CsvColumns
          # import data
          lines.each { |line| create(Hash[*header.zip(line).flatten]) }
        else
          puts "ERROR: Expecting #{self::CsvColumns.join(',')} on '#{fname}'. Skipping import of #{name.downcase.pluralize}."
          false
        end
      rescue Errno::EISDIR
        puts "ERROR: '#{fname}' is a directory. #{name.pluralize} not imported."
      rescue Errno::EACCES
        puts "ERROR: Permission denied on '#{fname}'. #{name.pluralize} not imported."
      rescue Errno::ENOENT
        puts "ERROR: '#{fname}' not found. #{name.pluralize} not imported."
      end
    end
  end # ClassMethods

  module InstanceMethods
    def association_to_csv(assoc_sym, fname)
      csv_data = association(assoc_sym).klass::CsvColumns
      csv_data.collect! { |d| d.to_s }
      begin
        CSV.open(fname, 'w') do |csv|
          # header
          csv << csv_data
          # iterate children
          association(assoc_sym).target.collect do |c|
            line = []
            csv_data.each { |d| line << c[d] }
            # export data
            csv << line
          end
        end
      rescue Errno::EISDIR
        puts "ERROR: '#{fname}' is a directory. #{assoc_sym.to_s.titleize.pluralize} not imported."
      rescue Errno::EACCES
        puts "ERROR: Permission denied on '#{fname}'. #{assoc_sym.to_s.titleize.pluralize} not imported."
      end
    end

    def association_from_csv(assoc_sym, fname)
      csv_data = association(assoc_sym).klass::CsvColumns
      csv_data.collect! { |d| d.to_s }
      begin
        lines = CSV.read(fname)
        header = lines.shift
        # check header
        if header == csv_data
          # import data
          lines.each { |line| association(assoc_sym).create(Hash[*header.zip(line).flatten]) }
        else
          puts "ERROR: Expecting #{csv_data.join(',')} on '#{fname}'. Skipping import of #{assoc_sym.to_s.pluralize}."
          false
        end
      rescue Errno::EISDIR
        puts "ERROR: '#{fname}' is a directory. #{assoc_sym.to_s.titleize.pluralize} not imported."
      rescue Errno::EACCES
        puts "ERROR: Permission denied on '#{fname}'. #{assoc_sym.to_s.titleize.pluralize} not imported."
      rescue Errno::ENOENT
        puts "ERROR: '#{fname}' not found. #{assoc_sym.to_s.titleize.pluralize} not imported."
      end
    end
  end # InstanceMethods
end


