class ProtocolsController < AuthorizedController
  before_filter :load_resources_from_part, only: [:new, :create]
  before_filter :load_resources_from_protocol, except: [:new, :create]

  def show
  end

  def new
  end

  def create
    if load_existing_images && @protocol.update_attributes(params[:protocol])
      redirect_to @protocol, notice: 'Successfully updated protocol.'
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if load_existing_images && @protocol.update_attributes(params[:protocol])
      redirect_to @protocol, notice: 'Successfully updated protocol.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @protocol.destroy
    redirect_to @part, notice: 'Successfully destroyed protocol.'
  end

private
  def load_resources_from_part
    @part = Part.find(params[:part_id])
    @protocol = @part.protocols.build
  end

  def load_resources_from_protocol
    @part = @protocol.part
  end
end
