class Part < ActiveRecord::Base
  # # # # # Includes / Extends          # # # # #
  extend  CsvSerialize::ClassMethods
  include Tire::Model::Search
  include Tire::Model::Callbacks

  # # # # # Constants                   # # # # #
  CsvColumns = %w[number kind description]
  Kinds = %w[Carpet Label Lavatory Panel Seat Sidewall Subpart]
  #   Preset searches: [ search_text,  elasticsearch query ]
  SearchPresets = [ [ 'All parts, no subparts', '-Subpart' ],
                    [ 'Seats', 'kind:Seat'],
                    [ 'Lavatories', 'kind:Lavatory'],
                    [ 'Carpets, Labels and Panels', 'kind:Carpet OR kind:Label OR kind:Panel'],
                    [ 'Subparts', 'kind:Subpart'],
                    [ 'All', '*'] ]

  # # # # # Instance Variables          # # # # #
  # # # # # Callbacks                   # # # # #
  # # # # # Attr_accessible / protected # # # # #
  attr_accessible :number, :kind, :description

  # # # # # Associations / Delegates    # # # # #
  has_many  :items, dependent: :destroy
  has_many  :protocols, dependent: :destroy
  has_one :checkpoint, dependent: :destroy
  accepts_nested_attributes_for :items, allow_destroy: true, reject_if: ->(i){ i[:name].blank? }
  accepts_nested_attributes_for :protocols, allow_destroy: true, reject_if: ->(p){ p[:revnum].blank? }

  # # # # # Scopes                      # # # # #
  default_scope order(:kind, :number)
  scope :subparts, where(kind: 'Subpart').order(:number)
  scope :except_subparts, where("kind != 'Subpart'").order(:kind, :number)
  scope :with_protocol, where('parts.id IN (SELECT part_id FROM protocols)')

  # # # # # Validations                 # # # # #
  validates :number, presence: true, uniqueness: true
  validates :kind, inclusion: { in: Kinds }

  # # # # # Public Methods              # # # # #
  def to_s
    number
  end

  def to_param
    "#{id}-#{number.parameterize}"
  end

  # Searching
  #   Model searching through ElasticSearch
  #   Index mappings
  mapping do
    indexes :id, type: 'integer'
    indexes :number, boost: 5, index: 'not_analyzed'
    indexes :description
    indexes :kind, boost: 10, index: 'not_analyzed'
    indexes :created_at, type: 'date', index: 'no'
    indexes :updated_at, type: 'date', index: 'no'
    indexes :current_protocol, index: 'not_analyzed'
  end

  def self.search(params = {})
    tire.search(page: params[:page], per_page: Kaminari.config.default_per_page) do
      query do
        boolean do
          must { string params[:preset] } if params[:preset].present?
          must { string params[:query] } if params[:query].present?
        end
      end
      # TODO:
      # Allow sorting by something passed on params, and sort on relevance
      sort { by [:kind, :number] }
    end
    #raise s.to_curl
  end

  #   Indexed methods. These are passible of showing / searching.
  def to_indexed_json
    to_json(methods: [:current_protocol])
  end

  def current_protocol
    protocols.current.to_s
  end

  #   Kaminari / Tire compatibility. Tire expects paginate method.
  def self.paginate(options = {})
    page(options[:page]).per(options[:per_page])
  end

  # # # # # Private Methods             # # # # #
  private
end
