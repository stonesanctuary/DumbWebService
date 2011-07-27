class ManagersController < ApplicationController
  def new
    @manager = Manager.new
    @title = "Sign up"
  end

  def show
    @manager = Manager.find(params[:id])
    @title = @manager.name
  end
  
  def create
    @manager = Manager.new(params[:manager])
    if @manager.save
      flash[:success] = "Welcome to Fizzbits"
      redirect_to @manager
    else
      @title = "Sign up"
      render 'new'
    end
  end
end
