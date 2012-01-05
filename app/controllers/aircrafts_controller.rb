class AircraftsController < AuthorizedController

  respond_to :html, :csv, :xls

  def index
    @aircrafts = Aircraft.order :registration
    respond_with @aircrafts
  end

  def show
    respond_with @aircraft
  end

  def new
  end

  def create
    if @aircraft.save
      redirect_to new_aircraft_konfiguration_path(@aircraft),
                  notice: "Successfully created #{@aircraft} aircraft."
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @aircraft.update_attributes(params[:aircraft])
      redirect_to @aircraft, notice: 'Successfully updated aircraft.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @aircraft.destroy
    redirect_to aircrafts_url, notice: 'Successfully destroyed aircraft.'
  end
end
