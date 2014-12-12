require 'rails_helper'

describe UsersController do
  before do
    @user = create_user
    @user2 = create_user(email: "venus@planet.com")
    @project = create_project
    @admin = create_user(admin: true, email: "admin@example.com")
    @updated_user = {
      user: {
        first_name: "Santa",
        last_name: "Claus",
        email: @user.email,
      },
      id: @user.id
    }
    @updated_admin = {
      user: {
        first_name: "Garfield",
        last_name: "Cat",
        email: @admin.email,
      },
      id: @admin.id
    }
  end

  describe "#index" do
    it "does not allow visitors to see index" do
      get :index
      expect(response.status).to redirect_to(signin_path)
    end

    it "allows non-admin to see index" do
      session[:user_id] = @user.id
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
    it "does not allow visitors to see the new user page" do
      get :new
      expect(response.status).to redirect_to(signin_path)
    end

    it "does not allow non-admin to see the new user page" do
      session[:user_id] = @user.id
      get :new
      expect(response.status).to eq(404)
    end

    it "allows admin to see the new user page" do
      session[:user_id] = @admin.id
      get :new
      expect(response.status).to eq(200)
    end
  end


  describe "#create" do
    it "doesn't let visitors create a user" do
      session[:user_id] = nil
      post :create, user: { name: "Mr. Rogers" }
      expect(response).to redirect_to(signin_path)
    end

    it "doesn't allow a non-admin user to create a user" do
      session[:user_id] = @user.id
      post :create, user: {
        first_name: "Ella",
        last_name: "Fitzgerald",
        email: "sing@loud.com",
        password: "five",
        password_confirmation: "five",
        admin: false
      }
      expect(response.status).to eq(404)
    end

    it "if admin, redirects to users on save" do
      session[:user_id] = @admin.id
      post :create, user: {
        first_name: "Puff",
        last_name: "Daddy",
        email: "country@music.com",
        password: "yo",
        password_confirmation: "yo",
        admin: false
      }
      expect(response).to redirect_to(users_path)
    end

    it "if admin, renders new if save is unsuccessful" do
      session[:user_id] = @admin.id
      post :create, :user => {name: ""}
      expect(response).to render_template('new')
    end
  end


  describe "#show" do
    it "doesn't let visitors see show page" do
      get :show, id: @user.id
      expect(response.status).to eq(302)
    end

    it "allows non-admin to see their own show page" do
      session[:user_id] = @user.id
      get :show, id: @user.id
      expect(response).to render_template('show')
    end

    it "does not non-admin to see another user's show page" do
      session[:user_id] = @user.id
      get :show, id: @user2.id
      expect(response.status).to eq(404)
    end

    it "allows admin to see to see their own show page" do
      session[:user_id] = @admin.id
      get :show, id: @admin.id
      expect(response).to render_template('show')
    end

    it "allows admin to see another user's show page" do
      session[:user_id] = @admin.id
      get :show, id: @user2.id
      expect(response).to render_template('show')
    end
  end


  describe "#edit" do
    it "doesn't allow visitors to see the edit page" do
      get :edit, id: @user.id
      expect(response.status).to redirect_to(signin_path)
    end

    it "allows non-admin to see their own edit page" do
      session[:user_id] = @user.id
      get :edit, id: @user.id
      expect(response.status).to render_template('edit')
    end

    it "does not non-admin to see another user's edit page" do
      session[:user_id] = @user.id
      get :edit, id: @user2.id
      expect(response.status).to eq(404)
    end

    it "allows admin to see to see their own edit page" do
      session[:user_id] = @admin
      get :edit, id: @admin.id
      expect(response.status).to render_template('edit')
    end

    it "allows admin to see to see another user's edit page" do
      session[:user_id] = @admin.id
      get :edit, id: @user.id
      expect(response.status).to render_template('edit')
    end
  end


  describe "#update" do
    it "doesn't allow visitors to update" do
      put :update, @updated_user
      expect(response.status).to redirect_to(signin_path)
    end

    it "allows non-admin to update themselves" do
      session[:user_id] = @user.id
      put :update, @updated_user
      expect(response).to redirect_to(users_path)
    end

    it "does not allow non-admin to update another user" do
      session[:user_id] = @user2.id
      put :update, @updated_user
      expect(response.status).to eq(404)
    end

    it "allows admin to update themselves" do
      session[:user_id] = @admin
      get :update, @updated_admin
      expect(response.status).to redirect_to(users_path)
    end

    it "allows admin to update another user" do
      session[:user_id] = @admin.id
      put :update, @updated_user
      expect(response.status).to redirect_to(users_path)
    end
  end


  describe "#destroy" do
    it "does not allow visitors to destroy and redirects to signin path" do
      delete :destroy, id: @project.id
      expect(response.status).to redirect_to(signin_path)
    end

    it "renders 404 if non-admin tries to destroy another user" do
      session[:user_id] = @user.id
      delete :destroy, id: @user2.id
      expect(response.status).to eq(404)
    end

    it "allows non-admin to destroy themselves and redirects to signin path" do
      session[:user_id] = @user.id
      delete :destroy, id: @user.id
      expect(response).to redirect_to(signin_path)
    end

    it "allows admin to destroy another user and redirects to users path" do
      session[:user_id] = @admin.id
      delete :destroy, id: @user.id
      expect(response.status).to redirect_to(users_path)
    end
  end
end
