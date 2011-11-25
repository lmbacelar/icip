class LocationsController < ApplicationController
  before_filter :load_resources_from_image, :only => [:new, :create]
  before_filter :load_resources_from_location, :except => [:index, :new, :create]

#   def index
#     @locations = Location.order(:name).where("name like ?", "%#{params[:term]}%")
#     respond_to do |format|
#       format.html
#       format.json { render json: @locations.map(&:name)}
#     end
#   end

  def new
    @location = @image.locations.build
  end

  def create
    @location = @image.locations.build(params[:location])
    if @location.save
      redirect_to @image, :notice => "Successfully created location."
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @location.update_attributes(params[:location])
      redirect_to @image, :notice  => "Successfully updated location."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @location.destroy
    redirect_to @image, :notice => "Successfully destroyed location."
  end

private
  def load_resources_from_image
    @image = Image.find(params[:image_id])
  end

  def load_resources_from_location
    @location = Location.find(params[:id])
    @image = @location.image
  end
end
