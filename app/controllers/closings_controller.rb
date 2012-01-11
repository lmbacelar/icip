class ClosingsController < AuthorizedController
  before_filter :load_resources_from_tasc, only: [:new, :create]
  before_filter :load_resources_from_closing, except: [:index, :new, :create]

  def new
    @closing = @tasc.build_closing
  end

  def create
    @location = @tasc.build_closing(params[:closing].merge({engineer_id: current_user.id}))
    if @tasc.save
      redirect_to @tasc, notice: 'Successfully closed task.'
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @closing.update_attributes(params[:closing])
      redirect_to edit_tasc_url(@tasc), notice: 'Successfully closed task.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @closing.destroy
    redirect_to @tasc, notice: 'Successfully re-opened task.'
  end

private
  def load_resources_from_tasc
    @tasc = Tasc.find(params[:tasc_id])
    @inspection = @tasc.inspection
    @item = @tasc.item
    @protocol = @tasc.item.part.protocols.current
    @images = @protocol.images
    @checkpoint = @tasc.checkpoint
    @location = @checkpoint.location
  end

  def load_resources_from_closing
    @tasc = @closing.tasc
  end
end
