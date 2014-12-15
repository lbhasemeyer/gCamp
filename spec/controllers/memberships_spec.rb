
require 'rails_helper'

describe MembershipsController do

  before do
    @user = create_user(email: "frank@sinatra.com")
    @user2 = create_user(email: "rafael@turtle.com")
    @admin = create_user(email: "dino@saur.com", admin: true)
    @projects = Project.all
    @project = create_project
    @updated_project = {
      project: {
        name: 'New Project'
      },
      id: @project.id
    }
    @member = create_user(email: "polar@bear.com")
    @membership = create_membership(
    user: @member,
    project: @project,
    title: 'Member'
    )
    @owner = create_user(email: "y@2k.com")
    @ownership = create_membership(
    user: @owner,
    project: @project,
    title: 'Owner'
    )
  end


  describe "#index" do
    it "does not allow visitors to see index" do
      session[:user_id] = nil
      get :index, project_id: @project.id
      expect(response.status).to redirect_to(signin_path)
    end

    it "does not allow non-members to see index" do
      session[:user_id] = @user.id
      get :index, project_id: @project.id
      expect(response.status).to eq(404)
    end

    it "if member saves, index view is rendered" do
      session[:user_id] = @member.id
      get :index, project_id: @project.id
      expect(response).to render_template('index')
    end

    it "if member saves, index view is rendered" do
      session[:user_id] = @owner.id
      get :index, project_id: @project.id
      expect(response).to render_template('index')
    end

    it "if admin saves, index view is rendered" do
      session[:user_id] = @admin.id
      get :index, project_id: @project.id
      expect(response).to render_template('index')
    end
  end


  describe "#create" do
    it "does not allow visitors to create" do
      session[:user_id] = nil
      post :create, project_id: @project.id
      expect(response.status).to redirect_to(signin_path)
    end

    it "doesn't allow non-members to create" do
      session[:user_id] = @user.id
      post :create, project_id: @project, membership_id: @membership
      expect(response.status).to eq(404)
    end

    it "doesn't allow members to create" do
      session[:user_id] = @member
      post :create, project_id: @project, membership_id: @membership
      expect(response.status).to eq(404)
    end

    it "allows owners to create, and redirects" do
      session[:user_id] = @owner
      post :create, project_id: @project.id, :membership => {project_id: @project.id, user_id: @user, title: "Owner"}
      expect(response).to redirect_to(project_memberships_path(@project))
    end

    it "allows admin to create, and redirects" do
      session[:user_id] = @admin
      post :create, project_id: @project.id, :membership => {project_id: @project.id, user_id: @user, title: "Member"}
      expect(response).to redirect_to(project_memberships_path(@project))
    end

    it "renders index if save fails" do
      session[:user_id] = @owner.id
      post :create, project_id: @project.id, :membership => {user: '', title: "Owner"}
      expect(response).to render_template('index')
    end
  end


  describe '#update' do
    it "does not allow visitors to update" do
      session[:user_id] = nil
      post :create, project_id: @project.id
      expect(response.status).to redirect_to(signin_path)
    end

    it "doesn't allow non-members to update" do
      session[:user_id] = @user
      put :update, project_id: @project.id, id: @member.id, membership: 'Owner'
      expect(response.status).to eq(404)
    end

    it "doesn't allow members to update" do
      session[:user_id] = @member
      put :update, project_id: @project.id, id: @member.id
      expect(response.status).to eq(404)
    end

    it "allows owners to update, and redirects to index" do
      session[:user_id] = @owner.id
      post :create, project_id: @project.id, :membership => {project_id: @project.id, user_id: @user, title: "Owner"}
      expect(response).to redirect_to(project_memberships_path(@project))
    end

    it "allows admin to update, and redirects to index" do
      session[:user_id] = @admin.id
      post :create, project_id: @project.id, :membership => {project_id: @project.id, user_id: @user, title: "Owner"}
      expect(response).to redirect_to(project_memberships_path(@project))
    end

    it "if owner save is unsuccessful, renders index" do
      session[:user_id] = @owner.id
      post :create, project_id: @project.id, :membership => {user: '', title: "Owner"}
      expect(response).to render_template('index')
    end

    it "if admin save is unsuccessful, renders index" do
      session[:user_id] = @admin.id
      post :create, project_id: @project.id, membership: {user: '', title: "Owner"}
      expect(response).to render_template('index')
    end
  end


  describe '#destroy' do
    it "does not allow visitors to delete" do
      session[:user_id] = nil
      post :create, project_id: @project.id
      expect(response.status).to redirect_to(signin_path)
    end

    it "does not allow member to delete" do
      session[:user_id] = @member
      delete :destroy, project_id: @project.id, id: @ownership.id
      expect(response.status).to eq(404)
    end

    it "allows owner to delete, and redirects to memberships index" do
      session[:user_id] = @owner
      delete :destroy, project_id: @project.id, id: @membership.id
      expect(response).to redirect_to(project_memberships_path(@project))
    end

    it "allows admin to delete, and redirects to memberships index" do
      session[:user_id] = @admin.id
      delete :destroy, project_id: @project.id, id: @membership.id
      expect(response).to redirect_to(project_memberships_path(@project))
    end

    it "redirects to memberships if the last owner is deleted" do
      session[:user_id] = @admin.id
      delete :destroy, project_id: @project.id, id: @ownership.id
      expect(response).to redirect_to(project_memberships_path(@project))
    end

    it "redirects to projects if member deletes self" do
      session[:user_id] = @member.id
      delete :destroy, project_id: @project.id, id: @membership.id
      expect(response).to redirect_to(projects_path)
    end
  end

end
