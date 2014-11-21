class TasksController < ApplicationController

  before_action do
    @project = Project.find(params[:project_id])
  end
  before_action :set_task, only: [:show, :edit, :update, :destroy]

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
    @comment = Comment.new
    @comments = Comment.all
  end

  def new
    @task = @project.tasks.new
  end

  def create
    @task = @project.tasks.new(task_params)
    respond_to do |format|
      if @task.save
        format.html { redirect_to project_tasks_path(@project), notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to project_tasks_path(@project), notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
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

    def set_task
      @task = @project.tasks.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:description, :complete, :due_date)
    end

end
