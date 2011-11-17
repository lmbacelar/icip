class InspectionsController < ApplicationController
  def index
    @inspections = Inspection.scoped
  end

  def show
    @inspection = Inspection.find(params[:id])
    @zone = @inspection.zone
    @konfiguration = @zone.konfiguration
    @aircraft = @konfiguration.aircraft
  end

  def destroy
    @inspection = Inspection.find(params[:id])
    @inspection.destroy
    redirect_to inspections_url, :notice => "Successfully destroyed inspection."
  end
end
