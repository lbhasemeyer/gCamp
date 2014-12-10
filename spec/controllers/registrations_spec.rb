require 'rails_helper'

describe RegistrationsController do
  describe '#new' do
    it 'renders the sign_in page for visitors' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe '#create' do
  end

end
