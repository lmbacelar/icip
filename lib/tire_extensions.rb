# This file contains extensions to Tire Objects
# In particular, class method to_ary on Collection,
# class method human_attribute_name on Item, and
# instance method attributes on Item are used by
# to_xls, to_csv lib's and necessary to get Tire
# to respond_with :xls or :csv
class Tire::Results::Collection
  # This is needed as it is used by respond_with
  def to_ary
    self.to_a
  end
end

class Tire::Results::Item
  def attributes
    @attributes.delete_if {|k, v| k[0] == '_' || [:highlight, :sort].include?(k)}
  end

  def self.human_attribute_name(c)
    # TODO: Make this I18n compatible
    c.to_s.humanize
  end
end
