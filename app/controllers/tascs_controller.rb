class TascsController < AuthorizedController
  before_filter :load_resources_from_inspection, only: [:new, :create]
  before_filter :load_resources_from_tasc, except: [:index, :new, :create]

  respond_to :html
  respond_to :csv, :xls, only: [:index, :show]

  def index
    #@tascs = Tasc.all
    params[:preset] ||= Tasc::SearchPresets.first[1] # if defined? Inspection::SearchPresets
    # If current_user cannot read an arbitrary nspection, filter by current_user
    params[:current_user_id] ||= current_user.id if cannot? :read, Tasc.new
    @tascs = Tasc.search(params)
    respond_with @tascs
  end

  def show
    @closing = @tasc.closing
    @protocol = @tasc.item.part.protocols.current
    @images = @protocol.images
    @checkpoint = @tasc.checkpoint
    @location = @checkpoint.location
  end

  def new
    @tasc = @inspection.tascs.build
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
    @item = @tasc.item
    @protocol = @item.part.protocols.current
    # TODO: Restrict further checkpoints.
    # Exclude all those with pending tascs on this or another inspection.
    @checkpoints = @protocol.checkpoints.sort_natural
    @locations = @protocol.locations.uniq
    @images = @protocol.images
  end

  def update
    if @tasc.update_attributes(params[:tasc])
      redirect_to edit_inspection_url(@inspection), notice: 'Successfully updated task.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @tasc.destroy
    redirect_to edit_inspection_url(@inspection), notice: 'Successfully destroyed task.'
  end

private
  def load_resources_from_inspection
    @inspection = Inspection.find(params[:inspection_id])
    @item = Item.find(params[:item_id])
    @protocol = @item.part.protocols.current
    # TODO: Restrict checkpoints further.
    # Exclude all those with pending tascs on this or another inspection.
    @checkpoints = @protocol.checkpoints.sort_natural
    @locations = @protocol.locations.uniq
    @images = @protocol.images
  end

  def load_resources_from_tasc
    @inspection = @tasc.inspection
  end
end
