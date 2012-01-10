class KonfigurationsController < AuthorizedController
  before_filter :load_resources_from_aircraft, only: [:index, :new, :create]
  before_filter :load_resources_from_konfiguration, except: [:index, :new, :create]

  respond_to :html
  respond_to :csv, :xls, only: [:index, :show]

  def index
    @konfigurations = @aircraft.konfigurations.order :number
    respond_with @konfigurations
  end

  def show
    respond_with @konfiguration
  end

  def new
    @konfiguration = @aircraft.konfigurations.build
    @konfiguration.number = 1 + ( @aircraft.konfigurations.maximum(:number) || 0 )
  end

  def create
    @konfiguration = @aircraft.konfigurations.build(params[:konfiguration])
    if @konfiguration.save
      redirect_to new_konfiguration_zone_path(@konfiguration),
                  notice: "Successfully created configuration #{@konfiguration}."
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @konfiguration.update_attributes(params[:konfiguration])
      redirect_to @aircraft, notice: 'Successfully updated configuration.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @konfiguration.destroy
    redirect_to @aircraft, notice: 'Successfully destroyed configuration.'
  end

private
  def load_resources_from_aircraft
    @aircraft = Aircraft.find(params[:aircraft_id])
  end

  def load_resources_from_konfiguration
    @aircraft = @konfiguration.aircraft
  end
end
