class ItemsController < ApplicationController
  before_filter :load_resources_from_zone, :only => [:new, :create]
  before_filter :load_resources_from_item, :except => [:new, :create]
  before_filter :set_image_params, :only => [:create, :update]

  def show
  end

  def new
    @item = @zone.items.build
    @location = @item.build_location
  end

  def create
    @item = @zone.items.build(params[:item])
    if @item.save
      redirect_to @item, :notice  => "Successfully updated item."
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @item.update_attributes(params[:item])
      redirect_to @item, :notice  => "Successfully updated item."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @item.destroy
    redirect_to @zone, :notice => "Successfully destroyed item."
  end

private
  def load_resources_from_zone
    @zone = Zone.find(params[:zone_id])
    @konfiguration = @zone.konfiguration
    @aircraft = @konfiguration.aircraft
  end

  def load_resources_from_item
    @image_id = 'test'
    @item = Item.find(params[:id])
    @zone = @item.zone
    @konfiguration = @zone.konfiguration
    @aircraft = @konfiguration.aircraft
    @location = @item.location || @item.build_location
  end

  def set_image_params
    image_id = params[:item][:location_attributes].delete(:image_id)
    params[:item][:location_attributes].merge!( {:image => Image.find(image_id)} ) unless image_id.empty?
  end
end
