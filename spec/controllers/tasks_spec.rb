require 'rails_helper'

describe ProjectsController do
  before do
    @user = create_user(email: "james@jamesbond.com")
    @user2 = create_user(email: "michael@finnegan.com")
    @admin = create_user(email: "admin@here.com", admin: true)
    @project = create_project
    @membership = create_membership(
    project: @project,
    user: @user,
    title: 'Member'
    )
    @owner = create_user
    @ownership = create_ownership(
    project: @project,
    user: @owner,
    title: 'Owner'
    )
    @task = create_task(
    project: @project
    )
  end


  describe "#index" do
    it "does not allow visitors to see index" do
      get :index
      expect(response.status).to redirect_to(signin_path)
    end

    it "does not allow non-members to see index" do
      session[:user_id] = @user2.id
      get :index
      expect(response.status).to eq(404)
    end

    it "allows project members to see index" do
      session[:user_id] = @user.id
      get :index
      expect(response.status).to eq(200)
    end

    it "allows project owners to see index" do
      session[:user_id] = @owner.id
      get :index
      expect(response.status).to eq(200)
    end

    it "allows admin to see index" do
      session[:user_id] = @admin.id
      get :index
      expect(response.status).to eq(200)
    end
  end


  describe "#new" do
    it "does not allow visitors to see the new task page" do
      get :new
      expect(response.status).to redirect_to(signin_path)
    end

    it "does not allow non-members to see the new task page" do
      session[:user_id] = @user.id
      get :new
      expect(response.status).to eq(404)
    end

    it "allows project members to see the new task page" do
      session[:user_id] = create_membership.user
      get :new
      expect(response.status).to eq(200)
    end

    it "allows project owners to see the new task page" do
      session[:user_id] = @owner
      get :new
      expect(response.status).to eq(200)
    end

    it "allows admin to see the new task page" do
      session[:user_id] = @admin.id
      get :new
      expect(response.status).to eq(200)
    end
  end


  describe "#create" do

    it "doesn't let visitors create a task" do
      session[:user_id] = nil
      post :create, :project => { name: "Walk Around Christmas Tree" }
      expect(response).to redirect_to(signin_path)
    end

    it "allows a user with no memberships to create a task" do
      session[:user_id] = @user
      post :create, :project => { name: "Make a Nalgene"}
      expect(response).to redirect_to(project_tasks_path(Project.all.first))
    end

    it "allows a member to create a task" do
      session[:user_id] = create_membership.user
      post :create, :project => { name: "Make a Nalgene"}
      expect(response).to redirect_to(project_tasks_path(Project.all.first))
    end

    it "allows an owner to create a task" do
      session[:user_id] = create_ownership.user
      post :create, :project => { name: "Make a Nalgene"}
      expect(response).to redirect_to(project_tasks_path(Project.all.first))
    end

    it "allows an admin to create a task" do
      session[:user_id] = @admin
      post :create, :project => { name: "Eat 81 Cookies"}
      expect(response).to redirect_to(project_tasks_path(Project.all.first))
    end

    it "redirects to project tasks on save" do
      session[:user_id] = @user
      post :create, :project => {name: "Eat Apple while on Head"}
      expect(response).to redirect_to(project_tasks_path(Project.all.first))
    end

    it "renders new if save is unsuccessful" do
      session[:user_id] = @user
      post :create, :project => {name: ""}
      expect(response).to render_template('new')
    end
  end


  describe "#show" do

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
      session[:user_id] = create_membership.user
      get :show, id: @project.id
      expect(response.status).to eq(200)
    end

    it "allows project owners to see show page" do
      session[:user_id] = create_ownership.user
      get :show, id: @project.id
      expect(response.status).to eq(200)
    end

    it "allows admin to see show page" do
      @user = create_user(admin: true, email: "admin@example.com")
      session[:user_id] = @user.id
      get :show, id: @project.id
      expect(response.status).to eq(200)
    end
  end


  describe "#edit" do

    it "does not allow visitors to see edit page" do
      get :edit, id: @project.id
      expect(response.status).to redirect_to(signin_path)
    end

    it "does not allow non-members to see edit page" do
      session[:user_id] = @user.id
      get :edit, id: @project.id
      expect(response.status).to eq(404)
    end

    it "does not allow project members to see edit page" do
      session[:user_id] = create_membership.user
      get :edit, id: @project.id
      expect(response.status).to eq(404)
    end

    it "allows project owners to see edit page" do
      session[:user_id] = create_ownership.user
      get :edit, id: @project.id
      expect(response.status).to eq(200)
    end

    it "allows admin to see edit page" do
      @user = create_user(admin: true, email: "admin@example.com")
      session[:user_id] = @user.id
      get :edit, id: @project.id
      expect(response.status).to eq(200)
    end
  end


  describe "#update" do
    it "does not allow visitors to update an existing task" do
      get :edit, id: @project.id
      expect(response.status).to redirect_to(signin_path)
    end

    it "does not allow unassociated users to update an existing task" do
      session[:user_id] = @user
      put :update, @updated_project
      expect(response.status).to eq(404)
    end

    it "does not allow members to update task" do
      session[:user_id] = create_membership.user
      put :update, @updated_project
      expect(response.status).to eq(404)
    end

    it "allows owners to update task and redirect to task show page" do
      session[:user_id] = create_ownership.user
      put :update, @updated_project
      expect(response).to redirect_to(project_path(Project.first))
    end

    it "allows admins to update task and be redirected" do
      session[:user_id] = @admin
      put :update, @updated_project
      expect(response.status).to eq(302)
    end

    it "renders edit view when update is unsuccessful" do
      session[:user_id] = create_ownership.user
      unsuccessful_project = {
        project: {
          name: ''
        },
        id: @project.id
      }
      put :update, unsuccessful_project
      expect(response).to render_template('edit')
    end
  end


  describe "#destroy" do

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
      session[:user_id] = create_membership.user
      get :destroy, id: @project.id
      expect(response.status).to eq(404)
    end

    it "allows project owners to destroy" do
      session[:user_id] = create_ownership.user
      get :destroy, id: @project.id
      expect(response.status).to eq(302)
    end

    it "allows admin to destroy" do
      @user = create_user(admin: true, email: "admin@example.com")
      session[:user_id] = @user.id
      get :destroy, id: @project.id
      expect(response.status).to eq(302)
    end
  end
end
