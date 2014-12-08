class UsersController < ApplicationController

  before_action :authorize_user, only: [:show, :edit, :update, :destroy]

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
      session[:user_id] = @user.id
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
    @user.destroy
    redirect_to users_url, notice: 'User was successfully deleted.'
  end

  private

  def authorize_user
    @user = User.find(params[:id])
    unless current_user == @user
      raise AccessDenied
    end
  end

  def user_params
    if current_user.admin 
      params.require(:user).permit(:first_name, :last_name, :email, :admin, :password, :password_confirmation)
    else
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end
    # foo = params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    # if current_user.admin
    #   foo = foo.permit(:admin)
    # end
  end

end
