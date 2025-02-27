require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }

    it { should validate_presence_of(:email) }
    it { should allow_value('test@example.com').for(:email) }
    it { should_not allow_value('invalid_email').for(:email) }

    context 'password validations' do
      it 'is invalid if the password is less than 8 characters' do
        user = build(:user, password: 'Abc1@')
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include(I18n.t('activerecord.errors.models.user.attributes.password.too_short', count: 8))
      end

      it 'is invalid if the password does not meet complexity requirements' do
        user = build(:user, password: 'password')
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include(I18n.t('activerecord.errors.models.user.attributes.password.invalid'))
      end

      it 'is valid with a strong password' do
        user = build(:user, password: 'StrongP@ss1', password_confirmation: 'StrongP@ss1')
        expect(user).to be_valid
      end
    end
  end
end
