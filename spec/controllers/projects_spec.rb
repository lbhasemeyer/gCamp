require 'rails_helper'

describe ProjectsController do

  describe "#index" do
    before do
      @user = create_user
      @project = create_project
    end

    it "does not allow visitors to see index" do
      get :index
      expect(response.status).to redirect_to(signin_path)
    end

    it "allows non-members to see index" do
      session[:user_id] = @user.id
      get :index
      expect(response.status).to eq(200)
    end

    it "allows project members to see index" do
      session[:user_id] = @user.id
      get :index
      expect(response.status).to eq(200)
    end

    it "allows project owners to see index" do
      session[:user_id] = @user.id
      get :index
      expect(response.status).to eq(200)
    end

    it "allows admin to see index" do
      @user = create_user(admin: true, email: "admin@example.com")
      session[:user_id] = @user.id
      get :index
      expect(response.status).to eq(200)
    end
  end


  describe "#new" do
    before do
      @user = create_user
      @user2 = create_user(email: "venus@planet.com")
      @project = create_project
    end

    it "does not allow visitors to see the new project page" do
      get :new
      expect(response.status).to redirect_to(signin_path)
    end

    it "allows non-members to see the new project page" do
      session[:user_id] = @user.id
      get :new
      expect(response.status).to eq(200)
    end

    it "allows project members to see the new project page" do
      session[:user_id] = create_membership.user
      get :new
      expect(response.status).to eq(200)
    end

    it "allows project owners to see the new project page" do
      session[:user_id] = create_ownership.user
      get :new
      expect(response.status).to eq(200)
    end

    it "allows admin to see the new project page" do
      @user = create_user(admin: true, email: "admin@example.com")
      session[:user_id] = @user.id
      get :new
      expect(response.status).to eq(200)
    end
  end


  describe "#create" do
    before do
      @user = create_user
      @user2 = create_user(email: "venus@planet.com")
      @admin = create_user(admin: true, email: "admin@example.com")
    end

    it "doesn't let visitors create a project" do
      session[:user_id] = nil
      post :create, :project => { name: "Walk Around Christmas Tree" }
      expect(response).to redirect_to(signin_path)
    end

    it "allows a user with no memberships to create a project" do
      session[:user_id] = @user
      post :create, :project => { name: "Make a Nalgene"}
      expect(response).to redirect_to(project_tasks_path(Project.all.first))
    end

    it "allows a member to create a project" do
      session[:user_id] = create_membership.user
      post :create, :project => { name: "Make a Nalgene"}
      expect(response).to redirect_to(project_tasks_path(Project.all.first))
    end

    it "allows an owner to create a project" do
      session[:user_id] = create_ownership.user
      post :create, :project => { name: "Make a Nalgene"}
      expect(response).to redirect_to(project_tasks_path(Project.all.first))
    end

    it "allows an admin to create a project" do
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
    before do
      @user = create_user
      @user2 = create_user(email: "venus@planet.com")
      @project = create_project
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
    before do
      @user = create_user
      @user2 = create_user(email: "venus@planet.com")
      @project = create_project
    end

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
    before do
      @user = create_user
      @user2 = create_user(email: "venus@planet.com")
      @admin = create_user(admin: true, email: "admin@example.com")
      @project = create_project
      @project2 = create_project
      @updated_project = {
        project: {
          name: 'Updated Project Name'
          }, id: @project.id}
    end

    it "does not allow visitors to update an existing project" do
      get :edit, id: @project.id
      expect(response.status).to redirect_to(signin_path)
    end

    it "does not allow unassociated users to update an existing project" do
      session[:user_id] = @user
      put :update, @updated_project
      expect(response.status).to eq(404)
    end

    it "does not allow members to update project" do
      session[:user_id] = create_membership.user
      put :update, @updated_project
      expect(response.status).to eq(404)
    end

    it "allows owners to update project and redirect to project show page" do
      session[:user_id] = create_ownership.user
      put :update, @updated_project
      expect(response).to redirect_to(project_path(Project.first))
    end

    it "allows admins to update project and be redirected" do
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
    before do
      @user = create_user
      @user2 = create_user(email: "venus@planet.com")
      @project = create_project
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
