require 'rails_helper'

RSpec.describe Order::UpdateShippingStatusJob, type: :job do
  let!(:orders) { create_list(:order, 3, status: Order::STATUS.index('processing')) }
  let!(:delivered_order) { create(:order, status: Order::STATUS.index('delivered')) }

  describe '#perform' do
    it 'enqueues CheckOrderStatusJob for non-delivered orders' do
      expect(Order::CheckOrderStatusJob).to receive(:perform_later).exactly(3).times
      described_class.perform_now
    end
  end

  describe 'after_perform callback' do
    it 'sends an email via Order::OperationManagerMailer' do
      mailer = double('mailer', deliver_now: true)
      expect(Order::OperationManagerMailer).to receive(:send_email).and_return(mailer)
      expect(mailer).to receive(:deliver_now)

      described_class.perform_now
    end
  end
end
