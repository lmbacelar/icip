class ItemsController < AuthorizedController
  before_filter :load_resources_from_zone, only: [:index, :new, :create]
  before_filter :load_resources_from_item, except: [:index, :new, :create]

  respond_to :html
  respond_to :csv, :xls, only: [:index, :show]

  def index
    @items = @zone.items.order :name
    respond_with @items
  end

  def show
    respond_with @item
  end

  def new
    @item = @zone.items.build
  end

  def create
    @item = @zone.items.build(params[:item])
    if @item.save
      redirect_to @item, notice: 'Successfully updated item.'
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @item.update_attributes(params[:item])
      redirect_to @item, notice: 'Successfully updated item.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @item.destroy
    redirect_to @zone, notice: 'Successfully destroyed item.'
  end

private
  def load_resources_from_zone
    @zone = Zone.find(params[:zone_id])
    @konfiguration = @zone.konfiguration
    @aircraft = @konfiguration.aircraft
  end

  def load_resources_from_item
    @zone = @item.zone
    @konfiguration = @zone.konfiguration
    @aircraft = @konfiguration.aircraft
    @location = @item.location
  end
end
