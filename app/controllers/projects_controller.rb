class ProjectsController < ApplicationController

  before_action :authorize_membership, only: [:show]
  before_action :authorize_owner, only: [:edit, :update, :destroy]

  def index
    @projects = Project.all
  end

  def show
    @project = Project.find(params[:id])
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to project_tasks_path(@project), notice: 'Project was successfully created'
      Membership.create(project_id: @project.id, user_id: current_user.id, title: "Owner")
    else
      render :new
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
      @project = Project.find(params[:id])
      if @project.update(project_params)
        redirect_to @project, notice: 'Project was successfully updated'
      else
        render :edit
      end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    redirect_to projects_url, notice: 'Project was successfully deleted.'
  end


  private

  def authorize_membership
    @project = Project.find(params[:id])
    unless current_user.is_project_member?(@project)
      raise AccessDenied
    end
  end

  def authorize_owner
    @project = Project.find(params[:id])
    unless current_user.is_owner?(@project)
      raise AccessDenied
    end
  end

  def project_params
    params.require(:project).permit(:name)
  end

end
