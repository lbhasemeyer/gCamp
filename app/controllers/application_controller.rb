class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :projects

  def current_user
    @user = User.find_by(id: session[:user_id])
  end

  helper_method :current_user

  protect_from_forgery with: :exception


  class AccessDenied < StandardError
  end

  rescue_from AccessDenied, with: :render_404


private

  def render_404
    render "public/404", status: 404, layout: false
  end

  def projects
    @projects = Project.all
  end

end
