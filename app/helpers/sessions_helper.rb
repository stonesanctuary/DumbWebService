module SessionsHelper
  
  def sign_in(manager)
    cookies.permanent.signed[:remember_token] = [manager.id, manager.salt]
    current_manager = manager
  end
  
  def sign_out
    cookies.delete(:remember_token)
    current_manager = nil
  end
  
  def current_manager
    @current_manager ||= manager_from_remember_token
  end
  
  def current_manager=(manager)
    @current_manager = manager
  end
  
  def current_manager?(manager)
    manager == current_manager
  end
  
  def signed_in?
    !current_manager.nil?
  end
  
  def deny_access
    store_location
    redirect_to signin_path, :notice => "please sign in to access this page."
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end
  
private

  def manager_from_remember_token
    Manager.authenticate_with_salt(*remember_token)
  end
  
  def remember_token
    cookies.signed[:remember_token] || [nil,nil]
  end
  
  def store_location
    session[:return_to] = request.fullpath
  end
  
  def clear_return_to
    session[:return_to] = nil
  end
end
