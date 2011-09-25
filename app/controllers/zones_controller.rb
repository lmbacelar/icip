class ZonesController < ApplicationController
  before_filter :load_resources_from_aircraft, :only => [:new, :create]
  before_filter :load_resources_from_zone, :except => [:new, :create]

  def show
  end

  def new
    @zone = @konfiguration.zones.build
  end

  def create
    @zone = @konfiguration.zones.build(params[:zone])
    if @zone.save
      redirect_to @zone, :notice  => "Successfully updated zone."
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @zone.update_attributes(params[:zone])
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
  def load_resources_from_aircraft
    @konfiguration = Konfiguration.find(params[:konfiguration_id])
    @aircraft = @konfiguration.aircraft
  end

  def load_resources_from_zone
    @zone = Zone.find(params[:id])
    @konfiguration = @zone.konfiguration
    @aircraft = @konfiguration.aircraft
  end
end
