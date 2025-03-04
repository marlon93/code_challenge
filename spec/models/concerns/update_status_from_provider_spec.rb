require 'rails_helper'

RSpec.describe Order::UpdateStatusFromProvider, type: :model do
  let(:order) { build(:order, carrier_name: 'Fedex') }

  describe '#update_status_from_provider!' do
    context 'when the adapter exists' do
      let(:strategy_class) { class_double('Order::Provider::FedexStrategy', update_status: true) }

      before do
        stub_const('Order::Provider::FedexStrategy', strategy_class)
      end

      it 'calls update_status on the adapter' do
        expect(strategy_class).to receive(:update_status).with(order)
        order.update_status_from_provider!
      end
    end

    context 'when the adapter does not exist' do
      it 'returns false' do
        order.carrier_name = 'InvalidCarrier'
        expect(order.update_status_from_provider!).to be false
      end
    end
  end

  describe '#assign_carrier_id!' do
    context 'when the provider exists' do
      let(:shipment_class) { class_double('Fedex::Shipment', create: double(id: 123)) }

      before do
        stub_const('Fedex::Shipment', shipment_class)
      end

      it 'updates the carrier_id' do
        expect(order).to receive(:update!).with(carrier_id: 123)
        order.assign_carrier_id!
      end

      it 'returns true' do
        allow(order).to receive(:update!).and_return(true)
        expect(order.assign_carrier_id!).to be true
      end
    end

    context 'when the provider does not exist' do
      it 'returns false' do
        order.carrier_name = 'InvalidCarrier'
        expect(order.assign_carrier_id!).to be false
      end
    end

    context 'when an error occurs in update!' do
      before do
        allow(order).to receive(:update!).and_raise(ActiveRecord::RecordInvalid)
      end

      it 'logs an error and returns false' do
        expect(Rails.logger).to receive(:error).with(/ActiveRecord::RecordInvalid/)
        expect(order.assign_carrier_id!).to be false
      end
    end
  end
end
