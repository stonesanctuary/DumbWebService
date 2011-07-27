class ManagersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => [:destroy]
  
  def destroy
    Manager.find(params[:id]).destroy
    flash[:success] = "Manager destroyed."
    redirect_to managers_path
  end
  
  def new
    @manager = Manager.new
    @title = "Sign up"
  end

  def show
    @manager = Manager.find(params[:id])
    @title = @manager.name
  end
  
  def index
    @title = "All managers"
    @managers = Manager.paginate(:page => params[:page])
  end
  
  def create
    @manager = Manager.new(params[:manager])
    if @manager.save
      sign_in @manager
      flash[:success] = "Welcome to Fizzbits"
      redirect_to @manager
    else
      @title = "Sign up"
      render 'new'
    end
  end
  
  def edit
    @title = "Edit Manager"
  end
  
  def update
    @manager = Manager.find(params[:id])
    if @manager.update_attributes(params[:manager])
      flash[:success] = "Profile updated."
      redirect_to @manager
    else
      @title = "Edit Manager"
      render 'edit'
    end
  end
  
private
  def authenticate
    deny_access unless signed_in?
  end
  
  def correct_user
    @manager = Manager.find(params[:id])
    redirect_to(root_path) unless current_manager?(@manager)
  end
  
  def admin_user
    redirect_to(signin_path) if current_manager.nil?
    redirect_to(root_path) if current_manager && !current_manager.admin?
  end
  
end
