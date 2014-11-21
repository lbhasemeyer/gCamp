class MembershipsController < ApplicationController
  before_action do
    @project = Project.find(params[:project_id])
  end

  def index
    @membership = Membership.new
    @memberships = @project.memberships
  end

  def create
    @membership = Membership.new(membership_params)
    if @membership.save
      redirect_to project_memberships_path, notice: "Membership was successfully created."
    else
      render :index
    end
  end

  def update
    membership = Membership.find(params[:id])
    membership.update(membership_params)
    if membership.save
      redirect_to project_memberships_path, notice: "Membership was successfully updated."
    else
      render :index
    end
  end

  def destroy
    membership = Membership.find(params[:id])
    membership.destroy
    redirect_to project_memberships_path, notice:  "Membership was successfully removed."
  end

  private

  def membership_params
    params.require(:membership).permit(:user_id, :title).merge(:project_id => params[:project_id])
  end
end



# class MembershipsController < ApplicationController
#
#   before_action do
#     @project = Project.find(params[:project_id])
#   end
#
#
#     def index
#       @membership = @project.memberships.new
#       @memberships = @project.memberships
#     end
#
#     def create
#       @membership = @project.memberships.new(membership_params)
#         if @membership.save
#           redirect_to project_memberships_path, notice: 'Membership was successfully created.'
#         else
#           render :index
#         end
#     end
#
#     def edit
#       @membership = @project.memberships.find(params[:id])
#     end
#
#     def update
#         @membership = @project.memberships.find(params[:id])
#         @membership.update(membership_params)
#         if @membership.save
#           redirect_to project_memberships_path, notice: 'Membership was successfully updated.'
#         else
#           render :index
#         end
#     end
#
#     def destroy
#       @membership = @project.memberships.find(params[:id])
#       @membership.destroy
#       redirect_to project_memberships_path, notice: 'Membership was successfully destroyed.'
#     end
#
#
#     private
#
#     def membership_params
#       params.require(:membership).permit(:title, :user_id)
#     end
#
# end
