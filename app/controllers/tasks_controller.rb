class TasksController < ApplicationController

  before_action do
    @project = Project.find(params[:project_id])
  end
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :authorize_membership

  def index
    if params[:filter_by] == "all"
      @tasks = @project.tasks
    elsif params[:filter_by] == "incomplete"
      @tasks = @project.tasks.where(complete:false)
    else
      @tasks = @project.tasks.where(complete:false)
    end
  end

  def show
    @comment = @task.comments.new
    @comments = @task.comments.all
  end

  def new
    @task = @project.tasks.new
  end

  def create
    @task = @project.tasks.new(task_params)
      if @task.save
        redirect_to project_tasks_path(@project), notice: 'Task was successfully created.'
      else
        render :new
      end
  end

  def edit
  end

  def update
      if @task.update(task_params)
        redirect_to project_tasks_path(@project), notice: 'Task was successfully updated.'
      else
        render :edit
      end
  end

  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to project_tasks_path(@project), notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private

    def authorize_membership
      unless current_user.projects.include?(@project) || current_user.admin
        raise AccessDenied
      end
    end

    def set_task
      @task = @project.tasks.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:description, :complete, :due_date)
    end

end
