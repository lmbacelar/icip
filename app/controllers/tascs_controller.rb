class TascsController < AuthorizedController
  before_filter :load_resources_from_inspection, only: [:new, :create]
  before_filter :load_resources_from_tasc, except: [:new, :create]

  def show
  end

  def new
    @tasc = @inspection.tascs.build
    @images = @item.part.protocols.current.images
    @checkpoints = @item.part.protocols.current.checkpoints.sort_natural
    #@checkpoint_locations = @checkpoints.includes(:location)
  end

  def create
    @tasc = @inspection.tascs.build(params[:tasc])
    @tasc.item_id = params[:item_id]
    @tasc.technician_id = current_user.id
    if @tasc.save
      redirect_to edit_inspection_url(@inspection), notice: 'Successfully created task.'
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @tasc.update_attributes(params[:tasc])
      redirect_to @inspection, notice: 'Successfully updated task.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @tasc.destroy
    redirect_to @inspection, notice: 'Successfully destroyed task.'
  end

private
  def load_resources_from_inspection
    @inspection = Inspection.find(params[:inspection_id])
    @item = Item.find(params[:item_id])
  end

  def load_resources_from_tasc
    @inspection = @tasc.inspection
  end
end
