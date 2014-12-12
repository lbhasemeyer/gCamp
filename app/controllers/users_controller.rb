class UsersController < ApplicationController

  before_action :authorize_user, only: [:show, :edit, :update, :destroy]
  before_action :authorize_admin, only: [:new, :create]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to users_path, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    if current_user.admin
      @user.destroy
      redirect_to users_url, notice: 'User was successfully deleted.'
    elsif current_user == @user
      @user.destroy
      redirect_to signin_path, notice: 'User was successfully deleted.'
    end
  end

  private

  def authorize_user
    @user = User.find(params[:id])
    unless current_user == @user || current_user.admin
      raise AccessDenied
    end
  end

  def authorize_admin
    unless current_user.admin
      raise AccessDenied
    end
  end

  def user_params
    if current_user.admin
      params.require(:user).permit(:first_name, :last_name, :email, :admin, :password, :password_confirmation, :tracker_token)
    else
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :tracker_token)
    end
    # foo = params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    # if current_user.admin
    #   foo = foo.permit(:admin)
    # end
  end

end
