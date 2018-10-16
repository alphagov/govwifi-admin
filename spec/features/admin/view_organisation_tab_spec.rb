require 'features/support/not_signed_in'
require 'features/support/sign_up_helpers'

describe 'the visibility of the organisation depending on user' do
  context 'when logged out' do
    before { visit organisations_path }

    it_behaves_like 'not signed in'
  end

  context 'when logged in as Admin' do
    let(:organisation) { create(:organisation) }
    let(:user) { create(:user, :confirmed, email: 'me@example.gov.uk', organisation: organisation, admin: true) }

    it 'displays the organisation tab' do
      sign_in_user user
      visit root_path

      expect(page).to have_link(nil, href: organisations_path)
    end
  end

  context 'when logged in as normal user' do
    let(:organisation) { create(:organisation) }
    let(:user) { create(:user, :confirmed, email: 'me@example.gov.uk', organisation: organisation) }

    it 'will not display the organisation tab' do
      sign_in_user user
      visit root_path

      expect(page).to_not have_link(nil, href: organisations_path)
    end

    it 'will redirect to root if users type address manually' do
      sign_in_user user
      visit organisations_path

      expect(page.current_path).to eq(root_path)
    end
  end

  context 'comparing signed up organisations' do
    let!(:organisation_def) { create(:organisation, name: "DEF") }
    let!(:organisation_xyz) { create(:organisation, name: "XYZ") }
    let!(:organisation_abc) { create(:organisation, name: "ABC") }
    let(:user) { create(:user, :confirmed, email: 'me@example.gov.uk', organisation: organisation_abc, admin: true) }

    it 'display list of organisations in alphabetical order' do
      sign_in_user user
      visit organisations_path

      expect(page.body).to match(/ABC.*DEF.*XYZ/m)
    end
  end
end
