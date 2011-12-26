class AircraftsController < AuthorizedController
  def index
    @aircrafts = Aircraft.order :registration
  end

  def show
  end

  def new
  end

  def create
    if @aircraft.save
      redirect_to @aircraft, notice: 'Successfully created aircraft.'
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
