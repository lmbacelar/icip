class KonfigurationsController < AuthorizedController
  before_filter :load_resources_from_aircraft, :only => [:new, :create]
  before_filter :load_resources_from_konfiguration, :except => [:new, :create]

  def show
  end

  def new
    @konfiguration = @aircraft.konfigurations.build
    @konfiguration.number = 1 + ( @aircraft.konfigurations.maximum(:number) || 0 )
  end

  def create
    @konfiguration = @aircraft.konfigurations.build(params[:konfiguration])
    if @konfiguration.save
      redirect_to @aircraft, :notice  => "Successfully updated configuration."
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @konfiguration.update_attributes(params[:konfiguration])
      redirect_to @aircraft, :notice  => "Successfully updated configuration."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @konfiguration.destroy
    redirect_to @aircraft, :notice => "Successfully destroyed configuration."
  end

private
  def load_resources_from_aircraft
    @aircraft = Aircraft.find(params[:aircraft_id])
  end

  def load_resources_from_konfiguration
    @aircraft = @konfiguration.aircraft
  end
end
