class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

private
  # Returns current logged in user, if any
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  # Takes params
  # Assigns already existing images to target
  # Removes already existing images from params
  def load_existing_images
    target = controller_name.singularize
    if params[target][:images_attributes].nil?
      true
    else
      params[target][:images_attributes].each do |k,v|
        if v[:file] && img = Image.find_by_checksum(Image.checksum(v[:file].tempfile))
          instance_variable_get("@#{target}").images << img
          params[target][:images_attributes].delete(k)
        end
      end
    end
  end
end
