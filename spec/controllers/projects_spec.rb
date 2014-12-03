# require 'rails-helper'
#
# describe ProjectsController do
#
#   describe "#edit" do
#
#     before do
#       @user = User.create!(
#         first_name: "Joe",
#         last_name: "Example",
#         password: "password",
#         email: "joe@example.com"
#       )
#       @project = Project.create!(
#         name: "Acme"
#       )
#     end
#
#     it "does not allow non-members" do
#       session [:user_id] = @user.id
#       get :edit, id: @project.id
#       expect(response.status).to eq(404)
#     end
#
#     it "does not allow project members" do
#       Membership.create!(
#         user: @user,
#         project: @project,
#         role: 'member'
#       )
#       session [:user_id] = @user.id
#       get :edit, id: @project.id
#       expect(response.status).to eq(404)
#     end
#
#     it "allows owners to edit" do
#       Membership.create!(
#         user: @user,
#         project: @project,
#         role: 'owner'
#       )
#       session [:user_id] = @user.id
#       get :edit, id: @project.id
#       expect(response.status).to eq(200)
#     end
#
#     it "allows admin to edit" do
#     end
#   end
