class PartsController < AuthorizedController
  def index
    params[:preset] ||= Part::SearchPresets.first[1] # if defined? Part::SearchPresets
    @parts = Part.search(params)
  end

  def show
  end

  def new
  end

  def create
    if @part.save
      redirect_to new_part_protocol_path(@part),
                  notice: "Successfully created part #{@part}."
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @part.update_attributes(params[:part])
      redirect_to @part, notice: 'Successfully updated part.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @part.destroy
    redirect_to parts_url, notice: 'Successfully destroyed part.'
  end

  def parts_autocomplete
    @parts = Part.except_subparts.where("number LIKE ?", "%#{params[:term]}%")
    render json: @parts.map(&:number)
  end

  def subparts_autocomplete
    @subparts = Part.subparts.where("number LIKE ?", "%#{params[:term]}%")
    render json: @subparts.map(&:number)
  end
end
