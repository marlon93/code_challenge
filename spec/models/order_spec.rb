require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:product) { create(:product, stock: 10) }
  let(:order) { create(:order, product: product, customer_name: 'John Doe', status: 'processing', carrier_name: 'Fedex') }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:product_id) }
    it { is_expected.to validate_presence_of(:customer_name) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:product).required }
  end

  describe 'callbacks' do
    context 'before validation' do
      it 'sets default values' do
        new_order = Order.new(product: product, customer_name: 'Jane Doe')
        new_order.valid?
        expect(new_order.status).to eq(Order::STATUS.index('processing'))
        expect(new_order.carrier_name).to eq('Fedex')
      end
    end

    context 'after commit' do
      it 'decrements stock after creation' do
        expect { order }.to change { product.reload.stock }.by(-1)
      end

      it 'enqueues AssignCarrierIdJob' do
        ActiveJob::Base.queue_adapter = :test
        expect { create(:order, product: product) }.to have_enqueued_job(Order::AssignCarrierIdJob)
      end
    end
  end

  describe '#soft_delete!' do
    it 'sets deleted_at timestamp' do
      expect { order.soft_delete! }.to change { order.reload.deleted_at }.from(nil)
    end
  end

  describe '#update_status_from_provider!' do
    context 'when provider strategy exists' do
      let(:strategy) { double('ProviderStrategy', update_status: true) }

      it 'calls update_status on the strategy' do
        allow("Order::Provider::FedexStrategy".safe_constantize).to receive(:update_status).and_return(true)
        expect(order.update_status_from_provider!).to eq(Order::Provider::FedexStrategy)
      end
    end

    context 'when provider strategy does not exist' do
      it 'returns false' do
        allow("Order::Provider::UnknownStrategy".safe_constantize).to receive(:update_status).and_return(nil)
        order.carrier_name = 'Unknown'
        expect(order.update_status_from_provider!).to be false
      end
    end
  end

  describe '#assign_carrier_id!' do
    context 'when shipping provider exists' do
      let(:shipment) { double('Shipment', id: 123) }
      let(:provider) { double('Fedex::Shipment', create: shipment) }

      it 'updates carrier_id' do
        allow("Fedex::Shipment".safe_constantize).to receive(:create).and_return(shipment)
        expect { order.assign_carrier_id! }.to change { order.reload.carrier_id }.to(123)
      end
    end

    context 'when shipping provider does not exist' do
      it 'returns false' do
        order.carrier_name = 'Unknown'
        expect(order.assign_carrier_id!).to be false
      end
    end
  end

  describe 'scopes' do
    let!(:delivered_order) { create(:order, status: Order::STATUS.index('delivered')) }
    let!(:pending_order) { create(:order, status: Order::STATUS.index('processing')) }

    describe '.excluding_delivered' do
      it 'excludes delivered orders' do
        expect(Order.excluding_delivered).to include(pending_order)
        expect(Order.excluding_delivered).not_to include(delivered_order)
      end
    end

    describe '.by_customer' do
      it 'filters by customer name' do
        expect(Order.by_customer('John')).to include(order)
        expect(Order.by_customer('Jane')).not_to include(order)
      end
    end

    describe '.by_status' do
      it 'filters by valid status' do
        expect(Order.by_status('processing')).to include(order)
      end

      it 'returns all when status is invalid' do
        expect(Order.by_status('invalid')).to include(order, delivered_order, pending_order)
      end
    end

    describe '.filter' do
      it 'applies all filters correctly' do
        expect(Order.filter(customer_name: 'John', status: 'processing')).to include(order)
      end
    end
  end
end
