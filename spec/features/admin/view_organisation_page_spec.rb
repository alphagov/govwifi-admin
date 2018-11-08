require 'features/support/not_signed_in'
require 'features/support/sign_up_helpers'
require 'features/support/user_not_authorised'

describe 'view details of a signed up organisations' do
  let(:organisation) { create(:organisation) }
  let!(:location) { create(:location, organisation: organisation) }
  let!(:ip) { create(:ip, location: location) }

  context 'when logged out' do
    before { visit admin_organisation_path(organisation) }

    it_behaves_like 'not signed in'
  end

  context 'when logged in as unpriviledged user' do
    let!(:user) { create(:user, :confirmed) }
    before do
      sign_in_user user
      visit admin_organisation_path(organisation)
    end
    it_behaves_like 'user not authorised'
  end

  context "when logged in" do
    let(:user) { create(:user, :confirmed, admin: true) }
    before(:each) do
      sign_in_user user
      visit admin_organisation_path(organisation)
    end

    it 'shows details page for the organisations' do
      expect(page).to have_content(organisation.name)
    end

    it 'has the creation date of the orgnisation' do
      expect(page).to have_content(organisation.created_at.strftime("%-e %b %Y"))
    end

    it 'has a Usage section' do
      expect(page).to have_content('Usage')
    end

    context 'when an organisation has a location' do
      it 'shows the number of locations' do
        within('#location-id') do
          expect(page).to have_content('1')
        end
      end
      it 'lists all locations'
    end

    context 'when an organisation has an IP' do
      it 'shows the number of IPs'
    end

    it 'lists users with contact details'
    it 'has a service email'

    it 'has an MoU upload button'

    context 'when an MoU exists' do
      it 'has a download button'
      it 'has upload date'
    end
  end
end
