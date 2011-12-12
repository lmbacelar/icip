class PartsController < AuthorizedController
  def index
    @parts = Part.order(:kind, :number).page(params[:page]).where("number like ?", "%#{params[:term]}%")
    respond_to do |format|
      format.html
      format.json { render json: @parts.map(&:number)}
    end
  end

  def show
  end

  def new
  end

  def create
    if @part.save
      redirect_to @part, :notice => "Successfully created part."
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @part.update_attributes(params[:part])
      redirect_to @part, :notice  => "Successfully updated part."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @part.destroy
    redirect_to parts_url, :notice => "Successfully destroyed part."
  end
end
