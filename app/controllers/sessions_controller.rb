class SessionsController < ApplicationController
#  force_ssl except: :destroy

  def create
    user = User.find_by_email(params[:login]) || User.find_by_tap_number(params[:login])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user.role?(:engineer) ? tascs_url : inspections_url, notice: 'Logged in!'
    else
      flash.now.alert = 'Invalid email or password'
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: 'Logged out!'
  end
end
