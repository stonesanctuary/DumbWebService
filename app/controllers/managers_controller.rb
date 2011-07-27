class ManagersController < ApplicationController
  def new
    @title = "Sign up"
  end

  def show
    @manager = Manager.find(params[:id])
    @title = @manager.name
  end
end
