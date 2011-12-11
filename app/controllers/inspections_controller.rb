class InspectionsController < AuthorizedController
#   before_filter do
#     Zone.schedule_inspections
#   end

  def index
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
