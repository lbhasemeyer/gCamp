# post create and update

require 'rails_helper'

describe ProjectsController do

  describe "#index" do
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

    it "does not allow visitors to see index" do
      get :index
      expect(response.status).to redirect_to(signin_path)
    end

    it "allows non-members to see" do
      session[:user_id] = @user.id
      get :index
      expect(response.status).to eq(200)
    end

    it "allows project members to see index" do
      Membership.create!(
        user: @user,
        project: @project,
        title: 'Member'
      )
      session[:user_id] = @user.id
      get :index
      expect(response.status).to eq(200)
    end

    it "allows project owners to see index" do
      Membership.create!(
        user: @user,
        project: @project,
        title: 'Owner'
      )
      session[:user_id] = @user.id
      get :index
      expect(response.status).to eq(200)
    end

    it "allows admin to see index" do
    end
  end

  describe "#new" do
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

    it "does not allow visitors to create project" do
      get :new
      expect(response.status).to redirect_to(signin_path)
    end

    it "allows non-members to create project" do
      session[:user_id] = @user.id
      get :new
      expect(response.status).to eq(200)
    end

    it "allows project members to create project" do
      Membership.create!(
        user: @user,
        project: @project,
        title: 'Member'
      )
      session[:user_id] = @user.id
      get :new
      expect(response.status).to eq(200)
    end

    it "allows project owners to create project" do
      Membership.create!(
        user: @user,
        project: @project,
        title: 'Owner'
      )
      session[:user_id] = @user.id
      get :new
      expect(response.status).to eq(200)
    end

    it "allows admin to create project" do
    end
  end


  describe "#show" do
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

    it "does not allow visitors to see show page" do
      get :show, id: @project.id
      expect(response.status).to redirect_to(signin_path)
    end

    it "does not allow non-members to see show page" do
      session[:user_id] = @user.id
      get :show, id: @project.id
      expect(response.status).to eq(404)
    end

    it "allows project members to see show page" do
      Membership.create!(
        user: @user,
        project: @project,
        title: 'Member'
      )
      session[:user_id] = @user.id
      get :show, id: @project.id
      expect(response.status).to eq(200)
    end

    it "allows project owners to see show page" do
      Membership.create!(
        user: @user,
        project: @project,
        title: 'Owner'
      )
      session[:user_id] = @user.id
      get :show, id: @project.id
      expect(response.status).to eq(200)
    end

    it "allows admin to see show page" do
    end
  end


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

    it "does not allow visitors to edit" do
      get :edit, id: @project.id
      expect(response.status).to redirect_to(signin_path)
    end

    it "does not allow non-members to edit" do
      session[:user_id] = @user.id
      get :edit, id: @project.id
      expect(response.status).to eq(404)
    end

    it "does not allow project members to edit" do
      Membership.create!(
        user: @user,
        project: @project,
        title: 'Member'
      )
      session[:user_id] = @user.id
      get :edit, id: @project.id
      expect(response.status).to eq(404)
    end

    it "allows project owners to edit" do
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


  describe "#destroy" do
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

    it "does not allow visitors to destroy" do
      get :destroy, id: @project.id
      expect(response.status).to redirect_to(signin_path)
    end

    it "does not allow non-members to destroy" do
      session[:user_id] = @user.id
      get :destroy, id: @project.id
      expect(response.status).to eq(404)
    end

    it "does not allow project members to destroy" do
      Membership.create!(
        user: @user,
        project: @project,
        title: 'Member',
      )
      session[:user_id] = @user.id
      get :destroy, id: @project.id
      expect(response.status).to eq(404)
    end

    it "allows project owners to destroy" do
      Membership.create!(
        user: @user,
        project: @project,
        title: 'Owner',
      )
      session[:user_id] = @user.id
      get :destroy, id: @project.id
      expect(response.status).to eq(302)
    end

    it "allows admin to destroy" do
    end
  end
end
