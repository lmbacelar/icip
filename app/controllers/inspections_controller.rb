class InspectionsController < AuthorizedController
#   before_filter do
#     Zone.schedule_inspections
#   end

  def index
    params[:preset] ||= Inspection::SearchPresets.first[1] # if defined? Inspection::SearchPresets
    @inspections = Inspection.search(params)
  end

  def show
    @zone = @inspection.zone
    @konfiguration = @zone.konfiguration
    @aircraft = @konfiguration.aircraft
  end

  def destroy
    @inspection.destroy
    redirect_to inspections_url, :notice => "Successfully destroyed inspection."
  end
end
