require 'features/support/not_signed_in'
require 'features/support/sign_up_helpers'

describe 'view list of signed up organisations', focus: true do
  before do
    login_as user
    visit organisations_path
  end

  context 'when not logged in' do
    let(:user) { nil }
    it_behaves_like 'not signed in'
  end

  context 'when logged in as a normal user' do
    let(:user) { create(:user, :confirmed) }

    it 'redirects me to the landing guidance' do
      expect(page).to have_content 'Get GovWifi'
      expect(page).to have_content 'Getting help'
    end
  end

  context 'when logged in as an admin' do
    let(:user) { create(:user, :confirmed, admin: true) }

    context 'and an organisation exists' do
      before do
        create(
          :organisation,
          name: "Bob's Burgers",
          created_at: '1 Feb 2014'
        )
        visit organisations_path
      end

      it 'shows their name' do
        expect(page).to have_content "Bob's Burgers"
      end

      it 'shows when they signed up' do
        expect(page).to have_content('1 Feb 2014')
      end
    end

    context 'and three organisations exist' do
      before do
        3.times { create(:organisation) }
        visit organisations_path
      end

      it 'shows all three organisations' do
        Organisation.all.each do |org|
          expect(page).to have_content(org.name)
        end
      end
    end
  end
end
