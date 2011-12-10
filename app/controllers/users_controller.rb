class UsersController < ApplicationController
  force_ssl :only => :new

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_url, :notice => 'Signep up!'
    else
      render 'new'
    end
  end
end
