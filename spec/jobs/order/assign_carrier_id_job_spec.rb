require 'rails_helper'

RSpec.describe Order::AssignCarrierIdJob, type: :job do
  let(:order) { create(:order, carrier_id: nil) }

  describe '#perform' do
    context 'when order exists and has no carrier_id' do
      it 'calls assign_carrier_id! on the order' do
        expect_any_instance_of(Order).to receive(:assign_carrier_id!)
        described_class.perform_now(order.id)
      end
    end

    context 'when order does not exist' do
      it 'does nothing' do
        expect { described_class.perform_now(-1) }.not_to raise_error
      end
    end

    context 'when order already has a carrier_id' do
      let(:order_with_carrier) { create(:order, carrier_id: 123) }

      it 'does not call assign_carrier_id!' do
        expect(order_with_carrier).not_to receive(:assign_carrier_id!)
        described_class.perform_now(order_with_carrier.id)
      end
    end
  end
end
