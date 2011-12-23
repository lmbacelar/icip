class Part < ActiveRecord::Base

  extend  CsvSerialize::ClassMethods
  CsvColumns = %w[number kind description]

  Kinds = %w[Carpet Label Lavatory Panel Seat Sidewall Subpart]

  attr_accessible :number, :kind, :description

  has_many  :items, :dependent => :destroy
  accepts_nested_attributes_for :items, :reject_if => lambda { |i| i[:name].blank? }, :allow_destroy => true
  has_many  :protocols, :dependent => :destroy
  accepts_nested_attributes_for :protocols, :reject_if => lambda { |p| p[:revnum].blank? }, :allow_destroy => true
  has_one :checkpoint, :dependent => :destroy

  validates :number, :presence => true, :uniqueness => true
  validates :kind, :inclusion => { :in => Kinds }

  default_scope order(:kind, :number)

  def to_s
    number
  end

  # Searching
  #
  #   Model searching through ElasticSearch
  #
  include Tire::Model::Search
  include Tire::Model::Callbacks
  #
  #   Preset searches: { search_text => elasticsearch query }
  SearchPresets = [ [ 'All parts, no subparts', '-Subpart' ],
                    [ 'Seats', 'kind:Seat'],
                    [ 'Lavatories', 'kind:Lavatory'],
                    [ 'Carpets, Labels and Panels', 'kind:Carpet OR kind:Label OR kind:Panel'],
                    [ 'Subparts', 'kind:Subpart'],
                    [ 'All', '*'] ]
  #
  #   Index mappings
  mapping do
    indexes :id, type: 'integer'
    indexes :number, boost: 5, index: 'not_analyzed'
    indexes :description
    indexes :kind, boost: 10, index: 'not_analyzed'
    indexes :created_at, type: 'date', index: 'no'
    indexes :updated_at, type: 'date', index: 'no'
    indexes :current_protocol_rev, type: 'integer'
  end
  #
  #   Search mappings, handling:
  #     autocomplete, preset searches, general queries, pagination and sorting
  def self.search(params = {})
    tire.search(:page => params[:page], :per_page => Kaminari.config.default_per_page) do
      if params[:term].present?
        # autocomplete-ui
        filter :prefix, 'number' => params[:term]
        filter :not, :term => { :kind => 'Subpart' }
        sort { by ['kind', 'number'] }
      else
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
        sort { by ['kind', 'number'] }
      end
      #raise s.to_curl
    end
  end
  #
  #   Indexed methods. These are passible of showing / searching.
  def to_indexed_json
    to_json(methods: [:current_protocol_rev])
  end
  #
  #     Gets current protocol revision number, if exists.
  #     Could be done through detailed mapping of protocols object but
  #     It is simpler like this, in this case.
  def current_protocol_rev
    protocols.current.try(:revnum)
  end
  #
  #   Kaminari / Tire compatibility. Tire expects paginate method.
  def self.paginate(options = {})
    page(options[:page]).per(options[:per_page])
  end
end
