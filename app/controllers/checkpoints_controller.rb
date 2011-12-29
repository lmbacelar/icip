class CheckpointsController < AuthorizedController
  before_filter :load_resources_from_protocol, only: [:index, :new, :create]
  before_filter :load_resources_from_checkpoint, except: [:index, :new, :create]

  def show
  end

  def new
    @checkpoint = @protocol.checkpoints.build
  end

  def create
    @checkpoint = @protocol.checkpoints.build(params[:checkpoint])
    if @checkpoint.save
      redirect_to @checkpoint, notice: 'Successfully updated checkpoint.'
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @checkpoint.update_attributes(params[:checkpoint])
      redirect_to @checkpoint, notice: 'Successfully updated checkpoint.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @checkpoint.destroy
    redirect_to @protocol, notice: 'Successfully destroyed checkpoint.'
  end

private
  def load_resources_from_protocol
    @protocol = Protocol.find(params[:protocol_id])
    @part = @protocol.part
  end

  def load_resources_from_checkpoint
    @protocol = @checkpoint.protocol
    @part = @protocol.part
    @location = @checkpoint.location
  end
end
