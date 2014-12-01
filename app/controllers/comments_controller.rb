class CommentsController < ApplicationController

  before_action :authorize

  before_action do
    @task = Task.find(params[:task_id])
    @project = Project.find(params[:project_id])
  end

  def create
    @comment = @task.comments.new(comment_params)
    @comment.save
    redirect_to project_task_path(@project, @task), notice: "Comment was successfully created."
  end


private

  def authorize
    unless current_user
      redirect_to signin_path, notice: "You must be logged in to access that action"
    end
  end

  def comment_params
  params.require(:comment).permit(:comment, :task_id, :user_id)
      .merge({:task_id => params[:task_id], :user_id => session[:user_id]})
    end

end
