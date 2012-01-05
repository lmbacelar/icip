class InspectionsController < AuthorizedController
  before_filter :load_resources_from_inspection, only: [:show, :edit]

  respond_to :html, :csv, :xls

  def index
    params[:preset] ||= Inspection::SearchPresets.first[1] # if defined? Inspection::SearchPresets
    # If current_user cannot read an arbitrary nspection, filter by current_user
    params[:current_user_id] ||= current_user.id if cannot? :read, Inspection.new
    @inspections = Inspection.search(params)
    respond_with @inspections
  end

  def show
    respond_with @inspection
  end

  def edit
    @inspectable_locatable_items = @zone.items.inspectable.locatable
  end

  def update
    if @inspection.update_attributes(params[:inspection])
      redirect_to inspections_url, notice: 'Successfully updated inspection.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @inspection.destroy
    redirect_to inspections_url, notice: 'Successfully destroyed inspection.'
  end

private
  def load_resources_from_inspection
    @zone = @inspection.zone
    @konfiguration = @zone.konfiguration
    @aircraft = @konfiguration.aircraft
  end
end
