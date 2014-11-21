class CommentsController < ApplicationController

  def index
    @membership = Membership.new
    @memberships = @project.memberships
  end

  def create
    @comment = @task.comment.new(comment_params)
    if @comment.save
      redirect_to project_task_path
    else
      render :show
    end
  end

  def update
  end

  def destroy
  end


  private

  def comment_params
    params.require(:comment).permit(:comment, :created_at, :task_id, :user_id)
  end

end
