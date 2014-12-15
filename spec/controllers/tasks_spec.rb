require 'rails_helper'

describe TasksController do
  before do
    @user = create_user(email: "james@jamesbond.com")
    @admin = create_user(email: "admin@here.com", admin: true)
    @project = create_project
    @updated_project = {
      project: {
        name: "Find Waldo",
        project: @project
        }, id: @project.id}
    @member = create_user(email: "costco@member.com")
    @membership = create_membership(
    project: @project,
    user: @member,
    title: 'Member'
    )
    @owner = create_user(email: "icecream@user.com")
    @ownership = create_ownership(
    project: @project,
    user: @owner,
    title: 'Owner'
    )
    @task = create_task(
    description: "Find Eggnog",
    project: @project
    )
  end


  describe "#index" do
    it "does not allow visitors to see index" do
      get :index, project_id: @project.id
      expect(response.status).to redirect_to(signin_path)
    end

    it "does not allow non-members to see index" do
      session[:user_id] = @user.id
      get :index, project_id: @project.id
      expect(response.status).to eq(404)
    end

    it "allows project members to see index" do
      session[:user_id] = @member.id
      get :index, project_id: @project.id
      expect(response.status).to eq(200)
    end

    it "allows project owners to see index" do
      session[:user_id] = @owner.id
      get :index, project_id: @project.id
      expect(response.status).to eq(200)
    end

    it "allows admin to see index" do
      session[:user_id] = @admin.id
      get :index, project_id: @project.id
      expect(response.status).to eq(200)
    end
  end


  describe "#new" do
    it "does not allow visitors to see the new task page" do
      get :new, project_id: @project.id
      expect(response.status).to redirect_to(signin_path)
    end

    it 'does not allow non-members to see the new task page' do
      session[:user_id] = @user.id
      get :index, project_id: @project.id
      expect(response.status).to eq(404)
    end

    it "allows project members to see the new task page" do
      session[:user_id] = @member
      get :new, project_id: @project.id
      expect(response.status).to eq(200)
    end

    it "allows project owners to see the new task page" do
      session[:user_id] = @owner
      get :new, project_id: @project.id
      expect(response.status).to eq(200)
    end

    it "allows admin to see the new task page" do
      session[:user_id] = @admin.id
      get :new, project_id: @project.id
      expect(response.status).to eq(200)
    end
  end


  describe "#create" do
    it "doesn't let visitors create a task" do
      session[:user_id] = nil
      post :create, :task => { name: "Grow Bamboo" }, project_id: @project.id
      expect(response).to redirect_to(signin_path)
    end

    it "doesn't allow non-members to create a task" do
      session[:user_id] = @user
      post :create, :task => { name: "Throw Paper off Roof"}, project_id: @project.id
      expect(response.status).to eq(404)
    end

    it "allows a member to create a task" do
      session[:user_id] = @member
      post :create, :task => { name: "Carry a Camel"}, project_id: @project.id
      expect(response.status).to eq(200)
    end

    it "allows an owner to create a task" do
      session[:user_id] = @owner
      post :create, :task => { name: "Make a Nalgene"}, project_id: @project.id
      expect(response.status).to eq(200)
    end

    it "allows an admin to create a task" do
      session[:user_id] = @admin
      post :create, :task => { name: "LOTR Marathon"}, project_id: @project.id
      expect(response.status).to eq(200)
    end

    it "redirects to project tasks on save" do
      session[:user_id] = @admin
      post :create, :task => {description: "Hello"}, project_id: @project.id
      expect(response).to redirect_to(project_tasks_path(@project))
    end

    it "renders new if save is unsuccessful" do
      session[:user_id] = @member
      post :create, :task => {description: nil}, project_id: @project.id
      expect(response).to render_template("new")
    end
  end


  describe "#show" do
    it "does not allow visitors to see show page" do
      get :show, project_id: @project.id, id: @task.id
      expect(response.status).to redirect_to(signin_path)
    end

    it "does not allow non-members to see show page" do
      session[:user_id] = @user.id
      get :show, project_id: @project.id, id: @task.id
      expect(response.status).to eq(404)
    end

    it "allows project members to see show page" do
      session[:user_id] = @member.id
      get :show, project_id: @project.id, id: @task.id
      expect(response.status).to eq(200)
    end

    it "allows project owners to see show page" do
      session[:user_id] = @owner.id
      get :show, project_id: @project.id, id: @task.id
      expect(response.status).to eq(200)
    end

    it "allows admin to see show page" do
      session[:user_id] = @admin.id
      get :show, project_id: @project.id, id: @task.id
      expect(response.status).to eq(200)
    end
  end


  describe "#edit" do
    it "does not allow visitors to see edit page" do
      get :edit, project_id: @project.id, id: @task.id
      expect(response.status).to redirect_to(signin_path)
    end

    it "does not allow non-members to see edit page" do
      session[:user_id] = @user.id
      get :edit, project_id: @project.id, id: @task.id
      expect(response.status).to eq(404)
    end

    it "allows project members to see edit page" do
      session[:user_id] = @member
      get :edit, project_id: @project.id, id: @task.id
      expect(response.status).to eq(200)
    end

    it "allows project owners to see edit page" do
      session[:user_id] = @owner
      get :edit, project_id: @project.id, id: @task.id
      expect(response.status).to eq(200)
    end

    it "allows admin to see edit page" do
      @user = create_user(admin: true, email: "admin@example.com")
      session[:user_id] = @user.id
      get :edit, project_id: @project.id, id: @task.id
      expect(response.status).to eq(200)
    end
  end


  describe "#update" do
    it "does not allow visitors to update an existing task" do
      put :update, project_id: @project.id, id: @task.id, task: "Blow Bubble"
      expect(response.status).to redirect_to(signin_path)
    end

    it "does not allow unassociated users to update an existing project" do
      session[:user_id] = @user
      put :update, project_id: @project.id, id: @task.id, task: "Make New Friends"
      expect(response.status).to eq(404)
    end

    it "allows members to update task and redirect" do
      session[:user_id] = @member
      put :update, project_id: @project.id, id: @task.id, task: {description: "Make Tortillas"}
      expect(response).to redirect_to(project_tasks_path(@project))
    end

    it "allows owners to update task" do
      session[:user_id] = @owner
      put :update, project_id: @project.id, id: @task.id, task: {description: "Find Meatball Sub"}
      expect(response).to redirect_to(project_tasks_path(@project))
    end

    it "allows admins to update task and be redirected" do
      session[:user_id] = @admin
      put :update, project_id: @project.id, id: @task.id, task: {description: "Pack Lunchbox"}
      expect(response).to redirect_to(project_tasks_path(@project))
    end

    it "renders edit view when update is unsuccessful" do
      session[:user_id] = @owner
      put :update, project_id: @project.id, id: @task.id, task: {description: nil}
      expect(response).to render_template('edit')
    end
  end


  describe "#destroy" do
    it "does not allow visitors to destroy" do
      session[:user_id] = nil
      delete :destroy, project_id: @project.id, id: @task.id
      expect(response.status).to redirect_to(signin_path)
    end

    it "does not allow non-members to destroy" do
      session[:user_id] = @user.id
      delete :destroy, project_id: @project.id, id: @task.id
      expect(response.status).to eq(404)
    end

    it "allows project members to destroy" do
      session[:user_id] = @member
      get :destroy, project_id: @project.id, id: @task.id
      expect(response.status).to eq(302)
    end

    it "allows project owners to destroy" do
      session[:user_id] = @owner
      get :destroy, project_id: @project.id, id: @task.id
      expect(response.status).to eq(302)
    end

    it "allows admin to destroy" do
      session[:user_id] = @admin
      get :destroy, project_id: @project.id, id: @task.id
      expect(response.status).to eq(302)
    end
  end
end
