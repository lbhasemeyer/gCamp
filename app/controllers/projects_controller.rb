class ProjectsController < ApplicationController

  before_action :authorize
  before_action :projects

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
      redirect_to @project, notice: 'Project was successfully created'
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

  def authorize
    unless current_user
      redirect_to signin_path, notice: "You must be logged in to access that action"
    end
  end

  def projects
    @projects = Project.all
  end

  def current_user
    @user = User.find_by(id: session[:user_id])
  end

  def project_params
    params.require(:project).permit(:name)
  end

end
