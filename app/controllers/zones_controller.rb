class ZonesController < ApplicationController
  before_filter :load_resources_from_konfiguration, :only => [:new, :create]
  before_filter :load_resources_from_zone, :except => [:new, :create]

  def show
  end

  def new
  end

  def create
    if load_existing_images && @zone.update_attributes(params[:zone])
      redirect_to @zone, :notice  => "Successfully updated zone."
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if load_existing_images && @zone.update_attributes(params[:zone])
      redirect_to @zone, :notice  => "Successfully updated zone."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @zone.destroy
    redirect_to @konfiguration, :notice => "Successfully destroyed zone."
  end

private
  def load_resources_from_konfiguration
    @konfiguration = Konfiguration.find(params[:konfiguration_id])
    @aircraft = @konfiguration.aircraft
    @zone = @konfiguration.zones.build
  end

  def load_resources_from_zone
    @zone = Zone.find(params[:id])
    @konfiguration = @zone.konfiguration
    @aircraft = @konfiguration.aircraft
  end

  def load_existing_images
    params[:zone][:images_attributes].each do |k,v|
      if v[:file] && img = Image.find_by_checksum(Image.checksum(v[:file].tempfile))
        @zone.images << img
        params[:zone][:images_attributes].delete(k)
      end
    end
  end
end
