class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end

  def create
    manager = Manager.authenticate(params[:session][:email], params[:session][:password])
    if manager.nil?
      flash.now[:error] = "Invalid email/password combination"
      @title = "Sign in"
      render 'new'
    else
      # sign in
      sign_in manager
      redirect_back_or manager
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
  
end
