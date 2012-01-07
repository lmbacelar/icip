class Inspection < ActiveRecord::Base
  # # # # # Includes / Extends          # # # # #
  include Tire::Model::Search
  include Tire::Model::Callbacks

  # # # # # Constants                   # # # # #
  # Preset searches: [ search_text, elasticsearch query ]
  SearchPresets = [ [ 'All', '*'],
                    [ 'Unassigned', 'state:Unassigned'],
                    [ 'Assigned', 'state:Assigned'],
                    [ 'Pending', 'state:Pending'],
                    [ 'Closed', 'state:Closed'] ]

  # # # # # Instance Variables          # # # # #
  # # # # # Callbacks                   # # # # #
  # # # # # Attr_accessible / protected # # # # #
  # # # # # Associations / Delegates    # # # # #
  belongs_to :zone
  has_many :inspection_assignments, dependent: :destroy
  has_many :technicians, through: :inspection_assignments, source: :user
  has_one :konfiguration, through: :zone
  has_one :aircraft, through: :konfiguration
  has_many :tascs, dependent: :destroy

  # # # # # Scopes                      # # # # #
  scope :unassigned, where('id NOT IN (SELECT inspection_id FROM inspection_assignments)')
  scope :assigned, select('DISTINCT inspections.*').joins(:inspection_assignments).where('inspections.execution_date IS NULL')
  scope :executed, where('inspections.execution_date IS NOT NULL')
  scope :pending, executed.joins(:tascs).merge(Tasc.pending)
  scope :clean, executed.where('id NOT IN (SELECT inspection_id FROM tascs)')
  scope :closed, clean + executed.joins(:tascs).merge(Tasc.closed)

  # # # # # Validations                 # # # # #
  # # # # # Public Methods              # # # # #
  def state
    if self.technicians.empty?
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
    execd.downcase if execd.is_a? String
    if [true, 1, '1', 't', 'T', 'true'].include? execd
      self.execution_date = Time.zone.now
    else
      self.execution_date = nil
    end
  end

  def technician_names
    if technicians.any?
      technicians.map{ |tec| tec.name }.join(', ')
    else
      nil
    end
  end

  def ordered_tascs
    self.tascs.joins(:item).order(:name)
  end

  # Searching
  #   Model searching through ElasticSearch
  #   Index mappings
  mapping do
    indexes :id, type: 'integer'
    indexes :state
    indexes :executed
    indexes :aircraft_registration, index: 'not_analyzed'
    indexes :zone_name, index: 'not_analyzed'
    indexes :created_at, type: 'date'
    indexes :updated_at, type: 'date'
    indexes :technician_ids, type: 'integer'
  end

  def self.search(params = {})
    tire.search(page: params[:page], per_page: Kaminari.config.default_per_page) do
      # regular search
      # TODO: Fix this to work with multiple technicians assigned to each inspection
      filter :term, technician_ids: params[:current_user_id] if params[:current_user_id]
      query do
        boolean do
          must { string params[:preset] } if params[:preset].present?
          must { string params[:query] } if params[:query].present?
        end
      end
      # TODO:
      # Allow sorting by something passed on params, and sort on relevance
      sort { by [{updated_at: {order: :desc}}, :aircraft_registration, :state] }
      #raise s.to_curl
    end
  end

  # Indexed methods. These are passible of showing / searching.
  def to_indexed_json
    to_json(methods: [:state, :executed, :aircraft_registration, :zone_name, :technician_ids])
  end

  # Gets aircraft.registration
  def aircraft_registration
    aircraft.registration
  end

  # Gets zone.name
  def zone_name
    zone.name
  end

  #   Kaminari / Tire compatibility. Tire expects paginate method.
  def self.paginate(options = {})
    page(options[:page]).per(options[:per_page])
  end

  # # # # # Private Methods             # # # # #
  private
end
