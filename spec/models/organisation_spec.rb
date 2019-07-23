describe Organisation do
  it { is_expected.to have_many(:users).through(:memberships) }
  it { is_expected.to have_many(:locations) }

  context 'when deleting an organisation' do
    let(:org) { create(:organisation) }
    let(:user) { create(:user, organisations: [org]) }
    let!(:location) { create(:location, organisation: org) }
    let!(:ip) { Ip.create(address: "1.1.1.1", location: location) }

    before { org.destroy }

    it 'removes all associated locations' do
      expect { location.reload }.to raise_error ActiveRecord::RecordNotFound
    end

    it 'removes all associated ip addresses' do
      expect { ip.reload }.to raise_error ActiveRecord::RecordNotFound
    end

    it 'removes all associated memberships' do
      expect(Membership.find_by(organisation_id: org.id)).to be_nil
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
        "Service email must be a valid email address"
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

  describe 'sortable_with_child_counts scope' do
    subject(:sorted_results) { described_class.sortable_with_child_counts(sort_column, sort_direction) }

    let(:first_organisation) { create(:organisation, name: 'An org', created_at: 1.day.ago) }
    let(:second_organisation) { create(:organisation, name: 'This org', created_at: 2.days.ago) }
    let(:first_location) { create(:location, organisation: first_organisation) }
    let(:second_location) { create(:location, organisation: second_organisation) }
    let(:third_location) { create(:location, organisation: second_organisation) }
    let(:first_ip) { create(:ip, location: first_location) }
    let(:second_ip) { create(:ip, location: first_location) }
    let(:third_ip) { create(:ip, location: second_location) }
    let(:fourth_ip) { create(:ip, location: third_location) }
    let(:sort_direction) { 'asc' }

    before do
      allow(described_class).to receive(:fetch_organisations_from_register)
        .and_return(['An org', 'This org'])

      first_location.ips = [first_ip, second_ip]
      second_location.ips << third_ip
      third_location.ips << fourth_ip

      first_organisation.locations << first_location
      second_organisation.locations = [second_location, third_location]

      first_organisation.signed_mou.attach(
        io: File.open(Rails.root + "spec/fixtures/mou.pdf"), filename: "mou.pdf"
      )
      second_organisation.signed_mou.attach(
        io: File.open(Rails.root + "spec/fixtures/mou.pdf"), filename: "mou.pdf"
      )

      second_organisation.signed_mou_attachment.update(created_at: 3.months.ago)
    end

    context 'when sorting by name' do
      let(:sort_column) { 'name' }

      it 'orders results alphabetically' do
        expect(sorted_results).to eq([first_organisation, second_organisation])
      end
    end

    context 'when sorting by created_at' do
      let(:sort_column) { 'created_at' }

      it 'orders results by date' do
        expect(sorted_results).to eq([second_organisation, first_organisation])
      end
    end

    context 'when sorting by signed mou' do
      let(:sort_column) { 'active_storage_attachments.created_at' }

      it 'orders results by date mou was signed' do
        expect(sorted_results).to eq([second_organisation, first_organisation])
      end
    end

    context 'when sorting by locations_count' do
      let(:sort_column) { 'locations_count' }

      it 'orders results by number of locations' do
        expect(sorted_results).to eq([first_organisation, second_organisation])
      end
    end

    context 'when sorting by ips_count' do
      let(:sort_column) { 'ips_count' }

      it 'orders results by number of ips' do
        expect(sorted_results).to eq([first_organisation, second_organisation])
      end
    end

    context 'when sorting in descending order' do
      let(:sort_column) { 'locations_count' }
      let(:sort_direction) { 'desc' }

      it 'orders results in descending order' do
        expect(sorted_results).to eq([second_organisation, first_organisation])
      end
    end
  end
end
