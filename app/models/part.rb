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

  # Model searching through ElasticSearch
  #
  include Tire::Model::Search
  include Tire::Model::Callbacks

  mapping do
    indexes :id, type: 'integer'
    indexes :number
    indexes :description
    indexes :kind
    indexes :current_protocol_rev, type: 'integer'
  end

  def self.search(params)
    tire.search(:page => params[:page], :per_page => Kaminari.config.default_per_page) do |s|
      if params[:term].present?
        # autocomplete-ui part number
        s.query { string "number:*#{params[:term]}*" }
      else
        # regular search
        s.query { string params[:query] } if params[:query].present?
      end
    end
  end

  def to_indexed_json
    to_json(methods: [:current_protocol])
  end

  def paginate
    page
  end

  def current_protocol_rev
    protocols.current.try(:revnum)
  end
end
