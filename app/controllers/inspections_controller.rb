class InspectionsController < AuthorizedController
  before_filter :load_resources_from_inspection, :only => [:show, :edit]
#   before_filter do
#     Zone.schedule_inspections
#   end

  def index
    params[:preset] ||= Inspection::SearchPresets.first[1] # if defined? Inspection::SearchPresets
    @inspections = Inspection.search(params)
  end

  def show
  end

  def edit
  end

  def update
    if @inspection.update_attributes(params[:inspection])
      redirect_to @inspection, :notice  => "Successfully updated inspection."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @inspection.destroy
    redirect_to inspections_url, :notice => "Successfully destroyed inspection."
  end

private
  def load_resources_from_inspection
    @zone = @inspection.zone
    @konfiguration = @zone.konfiguration
    @aircraft = @konfiguration.aircraft
  end
end
