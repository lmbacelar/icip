class ProtocolsController < ApplicationController
  before_filter :load_resources_from_part, :only => [:new, :create]
  before_filter :load_resources_from_protocol, :except => [:new, :create]

  def show
  end

  def new
    @protocol = @part.protocols.build
    @protocol.number = 1 + ( @part.protocols.maximum(:number) || 0 )
  end

  def create
    @protocol = @part.protocols.build(params[:protocol])
    if @protocol.save
      redirect_to @part, :notice  => "Successfully updated protocol."
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @protocol.update_attributes(params[:protocol])
      redirect_to @protocol, :notice  => "Successfully updated protocol."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @protocol.destroy
    redirect_to @part, :notice => "Successfully destroyed protocol."
  end

private
  def load_resources_from_part
    @part = Part.find(params[:part_id])
  end

  def load_resources_from_protocol
    @protocol = Protocol.find(params[:id])
    @part = @protocol.part
  end
end
