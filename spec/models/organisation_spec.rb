describe Organisation do
  context 'associations' do
    it { should have_many(:users) }
    it { should have_many(:locations) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }

    context 'when deleting an organisation as an admin' do
      let(:org) { create(:organisation) }

      let!(:user) { create(:user, organisation: org) }
      let!(:location) { create(:location, organisation: org) }
      let!(:ip) { Ip.create(address: "1.1.1.1", location: location) }

      it 'removes all of its children ' do
        org.destroy
        expect { user.reload }.to raise_error ActiveRecord::RecordNotFound
        expect { location.reload }.to raise_error ActiveRecord::RecordNotFound
        expect { ip.reload }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'Given my organisation is in the GovUk register' do
      it 'is valid' do
        organisation = build(:organisation, name: 'Org 1')
        expect(organisation).to be_valid
      end
    end

    context 'Given my organisation is not in the GovUk register' do
      it 'is not valid' do
        expect { create(:organisation, name: 'Some invalid organisation name') }.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end
end
