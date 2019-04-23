describe Organisation do
  it { is_expected.to have_many(:users) }
  it { is_expected.to have_many(:locations) }

  context 'when deleting an organisation' do
    let(:org) { create(:organisation) }
    let!(:user) { create(:user, organisation: org) }
    let!(:location) { create(:location, organisation: org) }
    let!(:ip) { Ip.create(address: "1.1.1.1", location: location) }

    before { org.destroy }

    it 'removes all associated users' do
      expect { user.reload }.to raise_error ActiveRecord::RecordNotFound
    end

    it 'removes all associated locations' do
      expect { location.reload }.to raise_error ActiveRecord::RecordNotFound
    end

    it 'removes all associated ip addresses' do
      expect { ip.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end

  context 'when name already exists' do
    before { create(:organisation, name: 'Gov Org 1') }

    it 'is not valid' do
      organisation = build(:organisation, name: 'Gov Org 1')
      expect(organisation).not_to be_valid
    end
  end

  context 'when an organisation name is in the register' do
    it 'is valid' do
      organisation = build(:organisation, name: 'Gov Org 1')
      expect(organisation).to be_valid
    end
  end

  context 'when an organisation name is not in the register' do
    let(:organisation) { build(:organisation, name: 'Some invalid organisation name') }

    it 'is not valid' do
      expect(organisation).not_to be_valid
    end

    it 'explains why it is invalid' do
      organisation.valid?
      expect(organisation.errors.full_messages).to eq([
        "#{organisation.name} isn't a whitelisted organisation"
      ])
    end
  end

  context 'when organisation name is left blank' do
    let(:organisation) { build(:organisation, name: '') }

    it 'is not valid' do
      expect(organisation).not_to be_valid
    end

    it 'explains why it is invalid' do
      organisation.valid?
      expect(organisation.errors.full_messages).to eq([
        "Name can't be blank"
      ])
    end
  end

  context 'when organisation service email is left blank' do
    let(:organisation) { build(:organisation, service_email: '') }

    it 'is not valid' do
      expect(organisation).not_to be_valid
    end

    it 'explains why it is invalid' do
      organisation.valid?
      expect(organisation.errors.full_messages).to eq([
        "Service email can't be blank"
      ])
    end
  end

  context 'when organisation service email is not an email address' do
    let(:organisation) { build(:organisation, service_email: 'IncorrectFormat') }

    it 'is not valid' do
      expect(organisation).not_to be_valid
    end

    it 'explains why it is invalid' do
      organisation.valid?
      expect(organisation.errors.full_messages).to eq([
        "Service email must be a valid email address"
      ])
    end
  end
end
