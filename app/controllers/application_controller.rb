class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  before_action :require_login

  def current_user
    User.find_by(id: session[:user_id])
  end

  helper_method :current_user
  protect_from_forgery with: :exception

  class AccessDenied < StandardError
  end

  rescue_from AccessDenied, with: :render_404


  private

  def set_return_point(path, overwrite = false)
    if overwrite or session[:return_point].blank?
      session[:return_point] = path
    end
  end

  def return_point
    session[:return_point] || projects_path
  end

  def require_login(return_point = request.url)
    unless current_user
      set_return_point(return_point)
      redirect_to signin_path, notice: "You must be logged in to access that action"
    end
  end

  def render_404
    render "public/404", status: 404, layout: false
  end

end
