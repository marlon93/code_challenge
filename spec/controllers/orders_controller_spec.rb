require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:product) { create(:product) }
  let!(:order) { create(:order, product: product) }

  before { session[:user_id] = user.id }

  describe 'GET #index' do
    it 'assigns @orders and renders the index template' do
      get :index
      expect(assigns(:orders)).to include(order)
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    it 'assigns a new order and renders the new template' do
      get :new
      expect(assigns(:order)).to be_a_new(Order)
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_params) { { order: { product_id: product.id, customer_name: 'John Doe' } } }

      it 'creates a new order and redirects' do
        expect {
          post :create, params: valid_params
        }.to change(Order, :count).by(1)
        expect(response).to redirect_to(orders_path)
        expect(flash[:notice]).to eq(I18n.t('orders.create.success'))
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { order: { product_id: nil, customer_name: '' } } }

      it 'does not create an order and renders new template with errors' do
        expect {
          post :create, params: invalid_params
        }.not_to change(Order, :count)
        expect(response).to render_template(:new)
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested order and renders the edit template' do
      get :edit, params: { id: order.id }
      expect(assigns(:order)).to eq(order)
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      let(:valid_params) { { id: order.id, order: { customer_name: 'Jane Doe' } } }

      it 'updates the order and redirects' do
        patch :update, params: valid_params
        expect(order.reload.customer_name).to eq('Jane Doe')
        expect(response).to redirect_to(orders_path)
        expect(flash[:notice]).to eq(I18n.t('orders.update.success'))
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { id: order.id, order: { customer_name: '' } } }

      it 'does not update the order and renders edit template with errors' do
        patch :update, params: invalid_params
        expect(order.reload.customer_name).not_to eq('')
        expect(response).to render_template(:edit)
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'soft deletes the order and redirects' do
      expect(order.deleted_at).to be_nil
      delete :destroy, params: { id: order.id }
      expect(order.reload.deleted_at).not_to be_nil
      expect(response).to redirect_to(orders_path)
      expect(flash[:notice]).to eq(I18n.t('orders.destroy.success'))
    end
  end
end
