class Tasc < ActiveRecord::Base
  # # # # # Includes / Extends          # # # # #
  include Tire::Model::Search
  include Tire::Model::Callbacks

  # # # # # Constants                   # # # # #
  # Preset searches: [ search_text, elasticsearch query ]
  SearchPresets = [ [ 'All', '*'],
                    [ 'Open', 'state:open'],
                    [ 'Closed', 'state:closed'],
                    [ 'Just Open Replacements', 'state:open AND action:Replace'],
                    [ 'Just Open Repairs', 'state:open AND action:Repair'] ]

  # # # # # Instance Variables          # # # # #
  Actions = %w[Repair Replace]
  Etrs = %w[1 4 A C]

  # # # # # Callbacks                   # # # # #
  # # # # # Attr_accessible / protected # # # # #
  # # # # # Associations / Delegates    # # # # #
  belongs_to :inspection
  belongs_to :item
  belongs_to :checkpoint
  belongs_to :technician, class_name: 'User'
  has_one :closing

  # # # # # Scopes                      # # # # #
  scope :pending, where('tascs.id NOT IN (SELECT tasc_id FROM closings)')
  scope :closed, joins(:closing)

  # # # # # Validations                 # # # # #
  validates :technician, presence: true
  validates :action, presence: true, inclusion: { in: Actions }
  validates :etr, presence: true, inclusion: { in: Etrs }
  validates :inspection, presence: true
  validates :item, presence: true
  validates :checkpoint, presence: true
  validates :checkpoint_id, uniqueness: { scope: [:inspection_id, :item_id] }

  # # # # # Public Methods              # # # # #
  def open?
    closing.nil?
  end

  def closed?
    not open?
  end

  def state
    if open?
      :open
    elsif closed?
      :closed
    end
  end

  def item_name
    item.name
  end

  def checkpoint_description
    checkpoint.part.description
  end

  def zone_name
    inspection.zone.name
  end

  def aircraft_registration
    inspection.zone.konfiguration.aircraft.registration
  end

  # Searching
  #   Model searching through ElasticSearch
  #   Index mappings
  mapping do
    indexes :id, type: 'integer'
    indexes :action
    indexes :etr
    indexes :state
    indexes :item_name
    indexes :checkpoint_description
    indexes :aircraft_registration, index: 'not_analyzed'
    indexes :zone_name, index: 'not_analyzed'
    indexes :created_at, type: 'date'
    indexes :updated_at, type: 'date'
  end

  def self.search(params = {})
    tire.search(page: params[:page], per_page: Kaminari.config.default_per_page) do
      # regular search
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
    to_json(methods: [:state, :item_name, :checkpoint_description, :aircraft_registration, :zone_name])
  end

  def self.paginate(options = {})
    page(options[:page]).per(options[:per_page])
  end

  # # # # # Private Methods             # # # # #
  private
end
