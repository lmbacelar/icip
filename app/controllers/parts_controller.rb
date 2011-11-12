class PartsController < ApplicationController
  def index
    @parts = Part.order(:number).where("number like ?", "%#{params[:term]}%")
    respond_to do |format|
      format.html
      format.json { render json: @parts.map(&:number)}
    end
  end

  def show
    @part = Part.find(params[:id])
  end

  def new
    @part = Part.new
  end

  def create
    @part = Part.new(params[:part])
    if @part.save
      redirect_to @part, :notice => "Successfully created part."
    else
      render :action => 'new'
    end
  end

  def edit
    @part = Part.find(params[:id])
  end

  def update
    @part = Part.find(params[:id])
    if @part.update_attributes(params[:part])
      redirect_to @part, :notice  => "Successfully updated part."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @part = Part.find(params[:id])
    @part.destroy
    redirect_to parts_url, :notice => "Successfully destroyed part."
  end
end
