require 'rails_helper'

describe MembershipsController do
  describe "#edit" do
    before do
      @project = Project.create!(
        name: "Acme"
      )
      @user = User.create!(
        first_name: "Joe",
        last_name: "Example",
        password: "password",
        email: "joe@example.com",
      )
    end

    it "does not allow non-logged in users" do
      @membership = Membership.create!(
        user: @user,
        project: @project,
        title: 'Member'
      )
      patch :update, project_id: @project.id, id: @membership.id
      expect(response.status).to redirect_to(signin_path)
    end

    it "does not allow non-members" do
      session[:user_id] = @user.id
      get :index, project_id: @project.id
      expect(response.status).to eq(404)
    end

    it "does not allow project members" do
      @membership = Membership.create!(
        user: @user,
        project: @project,
        title: 'Member'
      )
      session[:user_id] = @user.id
      patch :update, project_id: @project.id, id: @membership.id
      expect(response.status).to eq(404)
    end

    it "allows owners to edit" do
    end

    it "allows admin to edit" do
    end
  end
end
