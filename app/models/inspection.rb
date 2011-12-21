class Inspection < ActiveRecord::Base
  belongs_to :zone
  belongs_to :technician, :class_name => 'User'
  has_one :konfiguration, :through => :zone
  has_one :aircraft, :through => :konfiguration
  has_many :tascs, :dependent => :destroy
  accepts_nested_attributes_for :tascs, :reject_if => lambda { |a| a[:action].blank? ||
                                                                   a[:technician] }, :allow_destroy => true
  scope :unassigned, where('inspections.assigned_to IS NULL')
  scope :assigned, where('inspections.assigned_to IS NOT NULL AND inspections.execution_date IS NULL')
  scope :executed, where('inspections.execution_date IS NOT NULL')
  scope :pending, executed.joins(:tascs).merge(Tasc.pending)
  scope :clean, executed.where('id NOT IN (SELECT inspection_id FROM tascs)')
  scope :closed, clean + executed.joins(:tascs).merge(Tasc.closed)

  def state
    if self.assigned_to.nil?
      :unassigned
    elsif self.execution_date.nil?
      :assigned
    elsif self.tascs.pending.any?
      :pending
    else
      :closed
    end
  end

  def executed
    execution_date.present?
  end

  def executed=(execd)
    if execd
      self.execution_date = Time.zone.now
    else
      self.execution_date = nil
    end
  end

  # Searching
  #
  #   Model searching through ElasticSearch
  #
  include Tire::Model::Search
  include Tire::Model::Callbacks
  #
  #   Preset searches: { search_text => elasticsearch query }
  SearchPresets = [ [ 'Unassigned', 'state:Unassigned'],
                    [ 'Assigned', 'state:Assigned'],
                    [ 'Pending', 'state:Pending'],
                    [ 'Closed', 'state:Closed'],
                    [ 'All', '*'] ]
  #
  #   Index mappings
  mapping do
    indexes :id, type: 'integer'
    indexes :state
    indexes :aircraft_registration, index: 'not_analyzed'
    indexes :zone_name, index: 'not_analyzed'
    indexes :created_at, type: 'date'
    indexes :updated_at, type: 'date'
  end
  #
  #   Search mappings, handling:
  #     preset searches, general queries, pagination and sorting
  def self.search(params = {})
    tire.search(:page => params[:page], :per_page => Kaminari.config.default_per_page) do
      # regular search
      query do
        boolean do
          must { string params[:preset] } if params[:preset].present?
          must { string params[:query] } if params[:query].present?
        end
      end
      # TODO:
      #
      # Allow sorting by something passed on params, and sort on relevance
      sort { by ['state', 'created_at', 'aircraft_registration', 'zone_name'] }
      #raise s.to_curl
    end
  end
  #
  #   Indexed methods. These are passible of showing / searching.
  def to_indexed_json
    to_json(methods: [:state, :aircraft_registration, :zone_name])
  end
  #
  #     Gets aircraft.registration
  def aircraft_registration
    aircraft.registration
  end
  #
  #     Gets zone.name
  def zone_name
    zone.name
  end
  #
  #   Kaminari / Tire compatibility. Tire expects paginate method.
  def self.paginate(options = {})
    page(options[:page]).per(options[:per_page])
  end

end
