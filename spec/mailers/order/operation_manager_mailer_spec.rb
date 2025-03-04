require 'rails_helper'

RSpec.describe Order::OperationManagerMailer, type: :mailer do
  describe '#send_email' do
    subject(:mail) { described_class.send_email }

    before do
      allow(ENV).to receive(:fetch).with('MANAGER_EMAIL', nil).and_return(manager_email)
    end

    context 'when MANAGER_EMAIL is set' do
      let(:manager_email) { 'operation_manager@example.com' }

      it 'sends an email to the manager' do
        expect(mail.to).to eq(['operation_manager@example.com'])
      end

      it 'has the correct subject' do
        expect(mail.subject).to eq('The order batch shipping has been successfully updated.')
      end

      it 'is sent from the correct email' do
        expect(mail.from).to eq(['notifications@mancrates.com'])
      end
    end
  end
end
