RSpec.describe User do
  context 'associations' do
    it { should have_many(:ips) }
  end

  describe '#attempt_set_password' do
    let(:user) { create(:user, password: 'password') }
    context 'when passwords match' do
      let(:params) { { password: '123456', password_confirmation: '123456' } }

      it 'should set the users password' do
        expect { user.attempt_set_password(params) }.to change(user, :password)
        expect(user.errors.empty?).to eq(true)
      end
    end

    context 'when passwords do not match' do
      let(:params) { { password: '123456', password_confirmation: '1234567' } }
      it 'should not set the users password' do
        expect { user.attempt_set_password(params) }.to_not change(user, :password)
        expect(user.errors.empty?).to eq(false)
        expect(user.errors.full_messages).to eq(['Passwords must match'])
      end
    end
  end

  describe '#save' do
    subject { build(:user) }

    context 'with the factory-built model' do
      it { is_expected.to be_valid }
    end

    context 'with valid data' do
      subject { build(:user, email: 'name@gov.uk') }

      it { is_expected.to be_valid }

      context 'when saved' do
        before { subject.save }

        it 'sets the radius_secret_key' do
          expect(subject.radius_secret_key).to be_present
        end
      end
    end

    context 'with a non-gov.uk email' do
      subject { build(:user, email: 'name@arbitrary-domain.com') }

      it { is_expected.to_not be_valid }

      context 'when saved' do
        before { subject.save }

        it 'explains the email must be from the correct domain' do
          expect(subject.errors.full_messages).to eq(
            ['Email must be from a government domain']
          )
        end
      end
    end
  end
end
