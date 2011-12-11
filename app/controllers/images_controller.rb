class ImagesController < AuthorizedController
  def index
    @images = Image.all
  end

  def show
    @locations = @image.locations
  end
end
