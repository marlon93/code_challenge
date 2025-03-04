require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let!(:user) { create(:user, password: '12345678Mm*', password_confirmation: '12345678Mm*') }

  describe 'GET #new' do
    context 'when user is logged in' do
      before { session[:user_id] = user.id }

      it 'redirects to root path' do
        get :new
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is not logged in' do
      it 'renders the new template' do
        get :new
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid credentials' do
      let(:valid_params) do
        { email: user.email, password: '12345678Mm*', password_confirmation: '12345678Mm*' }
      end

      it 'sets the session user_id and redirects to root' do
        post :create, params: valid_params
        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq(I18n.t('controllers.sessions.welcome'))
      end
    end

    context 'with invalid credentials' do
      let(:invalid_params) do
        { email: user.email, password: 'wrongpassword', password_confirmation: 'wrongpassword' }
      end

      it 'renders new template with an alert' do
        post :create, params: invalid_params
        expect(session[:user_id]).to be_nil
        expect(response).to render_template(:new)
        expect(flash[:alert]).to eq(I18n.t('alerts.invalid_credentials'))
      end
    end
  end

  describe 'DELETE #destroy' do
    before { session[:user_id] = user.id }

    it 'clears the session and redirects to login' do
      delete :destroy
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(login_path)
      expect(flash[:notice]).to eq(I18n.t('alerts.logout_success'))
    end
  end
end
