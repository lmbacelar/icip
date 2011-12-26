class ImagesController < AuthorizedController
  def index
    @images = Image.all
  end

  def new
  end

  def create
    if @image.save
      redirect_to @image, notice: 'Successfully created image.'
    else
      render action: 'new'
    end
  end

  def show
    @locations = @image.locations
  end

  def destroy
    @image.destroy
    redirect_to images_url, notice: 'Successfully destroyed image.'
  end
end
