class ProjectsController < ApplicationController

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
    respond_to do |format|
      @project.save
      format.html { redirect_to @project, notice: 'Project was successfully created' }
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
      @project = Project.find(params[:id])
      @project.update(project_params)
      respond_to do |format|
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
      end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully deleted.' }
    end
  end




  private

  def project_params
    params.require(:project).permit(:name)
  end

end
