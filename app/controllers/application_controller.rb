class ApplicationController < ActionController::Base
  protect_from_forgery

  # Takes params
  # Assigns already existing images to target
  # Removes already existing images from params
  def load_existing_images
    target = controller_name.singularize
    params[target][:images_attributes].each do |k,v|
      if v[:file] && img = Image.find_by_checksum(Image.checksum(v[:file].tempfile))
        instance_variable_get("@#{target}").images << img
        params[target][:images_attributes].delete(k)
      end
    end
  end
end
