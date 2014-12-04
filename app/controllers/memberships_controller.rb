class MembershipsController < ApplicationController

  before_action do
    @project = Project.find(params[:project_id])
  end
  before_action :require_login
  before_action :authorize_membership
  before_action :authorize_owner, only: [:new, :create, :edit, :update]
  before_action :owner_or_membership_is_self, only: [:destroy]

  def index
    @membership = Membership.new
    @memberships = @project.memberships
  end

  def create
    @membership = Membership.new(membership_params)
    if @membership.save
      redirect_to project_memberships_path, notice: "#{@membership.user.full_name} was added successfully."
    else
      render :index
    end
  end

  def update
    @membership = @project.memberships.find(params[:id])
    @membership.update(membership_params)
    if @membership.save
      redirect_to project_memberships_path, notice: "#{@membership.user.full_name} was updated successfully."
    else
      render :index
    end
  end

  def destroy
    @membership = @project.memberships.find(params[:id])
      @membership.destroy
      redirect_to projects_path, notice: "#{@membership.user.full_name} was removed successfully."
    end

  private

  def require_login
    unless current_user
      redirect_to signin_path, notice: "You must be logged in to access that action"
    end
  end

  def authorize_membership
    current_user.projects.include?(@project)
    # project_list = Membership.where(user_id: current_user.id).pluck(:project_id)
    # unless project_list.include?(@project.id)
    #   raise AccessDenied
    # end
  end

  def owner_or_membership_is_self
    @project = Project.find(params[:project_id])
      unless current_user.is_owner?(@project) || current_user.is_member?(@project)
        raise AccessDenied
      end
  end

  def authorize_owner
    @project = Project.find(params[:project_id])
    unless current_user.is_owner?(@project)
      raise AccessDenied
    end
  end

  def membership_params
    params.require(:membership).permit(:user_id, :title).merge(:project_id => params[:project_id])
  end

end
