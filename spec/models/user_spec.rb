describe User do
  let(:organisation) { create(:organisation) }

  describe 'validation' do
    let(:user) { create(:user) }

    it 'has a valid factory user' do
      expect(user).to be_valid
    end

    ['password123', 'my password', 'pa55w0rd'].each do |weak_pass|
      it "does not accept a weak password (#{weak_pass})" do
        user.update(password: weak_pass)

        expect(user).to_not be_valid
      end
    end
  end

  it { is_expected.to have_many(:organisations).through(:memberships) }
  it { is_expected.to have_many(:memberships) }
  it { is_expected.to validate_presence_of(:name).on(:update) }

  context 'when checking if a membership is pending' do
    subject(:user) { create(:user, organisations: [organisation]) }

    let(:organisation) { create(:organisation) }

    it 'returns true if the membership is pending' do
      expect(user.pending_membership_for?(organisation: organisation)).to eq(true)
    end
  end

  describe '.super_admin?' do
    let(:superorg) { create(:organisation, super_admin: true) }
    let(:user) { create(:user) }

    describe 'when the user is part of the superadmin org' do
      it 'is true' do
        user.organisations << superorg

        expect(user).to be_super_admin
      end
    end

    context 'when the user has the superadmin attribute' do
      it 'is true' do
        user.update!(is_super_admin: true)

        expect(user).to be_super_admin
      end
    end

    context 'when the user is not part of the superadmin org' do
      it 'is false' do
        user.organisations << organisation

        expect(user).not_to be_super_admin
      end
    end

    context 'when the user is not superadmin' do
      it 'is false' do
        expect(user).not_to be_super_admin
      end
    end
  end

  describe '.new_super_admin?' do
    let(:user) { create(:user, :new_admin) }

    context 'with no organisations memberships' do
      it 'returns true' do
        expect(user).to be_new_super_admin
      end
    end

    context 'with a membership' do
      it 'returns false' do
        user.organisations << create(:organisation)

        expect(user).not_to be_new_super_admin
      end
    end
  end

  describe '.default_membership' do
    context 'with no memberships' do
      let(:user) { create(:user) }

      it 'returns nil' do
        expect(user.default_membership).to eq(nil)
      end
    end

    context 'with memberships' do
      let(:organisation_1) { create(:organisation) }
      let(:organisation_2) { create(:organisation) }
      let(:user) { create(:user, organisations: [organisation_1]) }

      before do
        user.organisations << organisation_2
      end

      it 'returns the first one' do
        expect(user.default_membership).to eq(user.membership_for(organisation_1))
      end
    end
  end

  describe 'need_two_factor_authentication?' do
    subject(:user) { create(:user, organisations: [organisation]) }

    let(:warden) { instance_double(Warden::Proxy, user: subject) }
    let(:request) { instance_double(ActionDispatch::Request, env: {'warden' => warden}) }
    let(:organisation) { create(:organisation) }

    context 'with super admins membership' do
      let(:organisation) { create(:organisation, super_admin: true) }

      it 'is true' do
        expect(user.need_two_factor_authentication?(request)).to be true
      end
    end

    context 'with a normal admin user' do
      it 'is false' do
        expect(user.need_two_factor_authentication?(request)).to be false
      end
    end

    context 'when bypassed with an environment variable' do
      let(:organisation) { create(:organisation, super_admin: true) }

      before { allow(ENV).to receive(:key?).with('BYPASS_2FA').and_return(true) }

      it 'is false' do
        expect(user.need_two_factor_authentication?(request)).to be false
      end
    end
  end
end
