class AircraftsController < ApplicationController
  def index
    @aircrafts = Aircraft.all
  end

  def show
    @aircraft = Aircraft.find(params[:id])
  end

  def new
    @aircraft = Aircraft.new
  end

  def create
    @aircraft = Aircraft.new(params[:aircraft])
    if @aircraft.save
      redirect_to @aircraft, :notice => "Successfully created aircraft."
    else
      render :action => 'new'
    end
  end

  def edit
    @aircraft = Aircraft.find(params[:id])
  end

  def update
    @aircraft = Aircraft.find(params[:id])
    if @aircraft.update_attributes(params[:aircraft])
      redirect_to @aircraft, :notice  => "Successfully updated aircraft."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @aircraft = Aircraft.find(params[:id])
    @aircraft.destroy
    redirect_to aircrafts_url, :notice => "Successfully destroyed aircraft."
  end
end
