class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

  def mimes_for_action(action)
    mimes = self.mimes_for_respond_to.dup
    action = action.to_sym
    mimes.delete_if { |k,v| (v[:only] && !v[:only].include?(action)) }
    mimes.delete_if { |k,v| (v[:except] && v[:except].include?(action)) }
  end

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

  # Rescue from incorrect search
  #
  # TODO:
  # Put this on a class or module.
  # Load only on SearcheableController.
  rescue_from Tire::Search::SearchRequestFailed do |error|
    # Indicate incorrect query to the user
    if error.message =~ /SearchParseException/ && params[:query]
      flash[:error] = "Sorry, your query '#{params[:query]}' is invalid..."
    else
      flash[:error] = 'Unexpected error on Tire Search... Could not return your results...'
      # ... handle other possible situations ...
    end
    redirect_to root_url
  end

end
