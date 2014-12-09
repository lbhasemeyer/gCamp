require 'rails_helper'

describe ProjectsController do
  describe "#edit" do
    before do
      @user = User.create!(
        first_name: "Joe",
        last_name: "Example",
        password: "password",
        email: "joe@example.com",
      )
      @project = Project.create!(
        name: "Acme"
      )
    end

    it "does not allow non-logged in users" do
      get :edit, id: @project.id
      expect(response.status).to redirect_to(signin_path)
    end

    it "does not allow non-members" do
      session[:user_id] = @user.id
      get :edit, id: @project.id
      expect(response.status).to eq(404)
    end

    it "does not allow project members" do
      Membership.create!(
        user: @user,
        project: @project,
        title: 'Member'
      )
      session[:user_id] = @user.id
      get :edit, id: @project.id
      expect(response.status).to eq(404)
    end

    it "allows owners to edit" do
      Membership.create!(
        user: @user,
        project: @project,
        title: 'Owner'
      )
      session[:user_id] = @user.id
      get :edit, id: @project.id
      expect(response.status).to eq(200)
    end

    it "allows admin to edit" do
    end
  end
  describe "#delete" do
    before do
      @user = User.create!(
        first_name: "Joe",
        last_name: "Example",
        password: "password",
        email: "joe@example.com",
      )
      @project = Project.create!(
        name: "Acme"
      )
    end

    it "does not allow non-members" do
      session[:user_id] = @user.id
      get :destroy, id: @project.id
      expect(response.status).to eq(404)
    end

    it "does not allow project members" do
      Membership.create!(
        user: @user,
        project: @project,
        title: 'Member'
      )
      session[:user_id] = @user.id
      get :destroy, id: @project.id
      expect(response.status).to eq(404)
    end

    it "allows project owners to delete" do
      Membership.create!(
        user: @user,
        project: @project,
        title: 'Owner'
      )
      session[:user_id] = @user.id
      count = Project.count
      get :destroy, id: @project.id
      expect(response.status).to eq(302)
      expect(@projects.count).to eq(count -1)
    end
    
    it "allows admin to delete" do
    end
  end
end
