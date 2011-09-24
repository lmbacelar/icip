class KonfigurationsController < ApplicationController

  def show
    @konfiguration = Konfiguration.find(params[:id])
    @aircraft = @konfiguration.aircraft
  end

  def new
    @aircraft = Aircraft.find(params[:aircraft_id])
    @konfiguration = @aircraft.konfigurations.build
    @konfiguration.number = 1 + ( @aircraft.konfigurations.maximum(:number) || 0 )
  end

  def create
    @aircraft = Aircraft.find(params[:aircraft_id])
    @konfiguration = @aircraft.konfigurations.build(params[:konfiguration])
    if @konfiguration.save
      redirect_to @aircraft, :notice  => "Successfully updated configuration."
    else
      render :action => 'new'
    end
  end

  def edit
    @konfiguration = Konfiguration.find(params[:id])
    @aircraft = @konfiguration.aircraft
  end

  def update
    @konfiguration = Konfiguration.find(params[:id])
    @aircraft = @konfiguration.aircraft
    if @konfiguration.update_attributes(params[:konfiguration])
      redirect_to @aircraft, :notice  => "Successfully updated configuration."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @konfiguration = Konfiguration.find(params[:id])
    @aircraft = @konfiguration.aircraft
    @konfiguration.destroy
    redirect_to @aircraft, :notice => "Successfully destroyed configuration."
  end
end
