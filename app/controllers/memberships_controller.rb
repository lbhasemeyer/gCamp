class MembershipsController < ApplicationController

  before_action do
    @project = Project.find(params[:project_id])
  end
  before_action :authorize_membership
  before_action :authorize_owner, only: [:new, :create, :edit, :update]
  before_action :authorize_destroy, only: [:destroy]

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
    if @membership.update(membership_params)
      redirect_to project_memberships_path, notice: "#{@membership.user.full_name} was updated successfully."
    else
      redirect_to project_memberships_path, notice: "You cannot change the last owner of a project."
    end
  end

  def destroy
    @membership = @project.memberships.find(params[:id])
    if @membership.destroy
      if current_user.is_owner?(@project) || current_user.admin
        redirect_to project_memberships_path, notice: "#{@membership.user.full_name} was removed successfully."
      else
        redirect_to projects_path, notice: "#{@membership.user.full_name} was removed successfully."
      end
    else
      redirect_to project_memberships_path, notice: "You cannot delete the last owner of a project.  Please fix this and try again."
    end
  end

  private

  def authorize_membership
    unless current_user.projects.include?(@project) || current_user.admin
      raise AccessDenied
    end
  end

  def authorize_owner
    @project = Project.find(params[:project_id])
    unless current_user.is_owner?(@project) || current_user.admin
      raise AccessDenied
    end
  end

  def authorize_destroy
    membership = Membership.find(params[:id])
    @project = Project.find(params[:project_id])
    unless current_user.is_owner?(@project)|| current_user == membership.user || current_user.admin
      raise AccessDenied
    end
  end

  def membership_params
    params.require(:membership).permit(:user_id, :title).merge(:project_id => params[:project_id])
  end

end
