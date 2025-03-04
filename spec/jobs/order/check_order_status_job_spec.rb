require 'rails_helper'

RSpec.describe Order::CheckOrderStatusJob, type: :job do
  let(:order) { create(:order) }

  describe '#perform' do
    context 'when the order exists' do
      it 'calls update_status_from_provider! on the order' do
        expect_any_instance_of(Order).to receive(:update_status_from_provider!)
        described_class.perform_now(order.id)
      end
    end

    context 'when the order does not exist' do
      it 'does nothing' do
        expect { described_class.perform_now(-1) }.not_to raise_error
      end
    end
  end
end
