require 'rails_helper'

RSpec.describe Order::Provider::FedexStrategy, type: :model do
  let(:order) { build(:order, carrier_id: 123, status: Order::STATUS.index('processing')) }
  let(:shipment) { double('Fedex::Shipment', status: 'shipped') }

  describe '.update_status' do
    context 'when the order is already delivered' do
      before do
        allow(order).to receive(:status).and_return(Order::STATUS.index('delivered'))
      end

      it 'does not update the order status' do
        expect(order).not_to receive(:update!)
        described_class.update_status(order)
      end
    end

    context 'when the order is not delivered' do
      before do
        allow(Fedex::Shipment).to receive(:find).with(order.carrier_id).and_return(shipment)
        allow(described_class).to receive(:status_index_for).with('shipped').and_return(2)
      end

      it 'updates the order status' do
        expect(order).to receive(:update!).with(status: 2)
        described_class.update_status(order)
      end
    end

    context 'when the order does not have a carrier_id' do
      before do
        order.carrier_id = nil
        allow(Fedex::Shipment).to receive(:create).and_return(shipment)
        allow(described_class).to receive(:status_index_for).with('shipped').and_return(2)
      end

      it 'creates a new shipment and updates the order status' do
        expect(order).to receive(:update!).with(status: 2)
        described_class.update_status(order)
      end
    end

    context 'when shipment is not found' do
      before do
        allow(Fedex::Shipment).to receive(:find).and_raise(Fedex::ShipmentNotFound)
      end

      it 'handles missing shipment and logs an error' do
        expect(order).to receive(:update!).with(carrier_id: nil)
        expect(Rails.logger).to receive(:error).with(/Shipment not found/)
        described_class.update_status(order)
      end
    end

    context 'when an error occurs' do
      before do
        allow(Fedex::Shipment).to receive(:find).and_raise(NoMethodError)
      end

      it 'handles the error and logs it' do
        expect(order).to receive(:update!).with(carrier_id: nil)
        expect(Rails.logger).to receive(:error).with(/Shipment not found/)
        described_class.update_status(order)
      end
    end
  end
end
