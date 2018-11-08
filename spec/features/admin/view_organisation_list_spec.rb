require 'features/support/not_signed_in'
require 'features/support/sign_up_helpers'

describe 'view list of signed up organisations' do
  before do
    login_as user
    visit admin_organisations_path
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

    context 'and one organisation exists' do
      let(:org) { create(:organisation, name: "Fake Org", created_at: '1 Feb 2014') }

      before do
        org.signed_mou.attach(
          io: File.open(Rails.root + "spec/fixtures/mou.pdf"), filename: "mou.pdf"
        )
        2.times { create(:location, organisation: org ) }
        3.times { create(:ip, location: Location.first) }
        visit admin_organisations_path
      end

      it 'shows their name' do
        within("table") do
          expect(page).to have_content 'Fake Org'
        end
      end

      it 'shows when they signed up' do
        within("table") do
          expect(page).to have_content('1 Feb 2014')
        end
      end

      it 'shows they have 10 locations' do
        within("table") do
          expect(page).to have_content('2')
        end
      end

      it 'shows they have 11 IPs' do
        within("table") do
          expect(page).to have_content('3')
        end
      end

      it 'shows they have an MOU' do
        within("table") do
          expect(page).to have_content(org.signed_mou.attachment.created_at.strftime('%e %b %Y'))
        end
      end
    end

    context 'and three organisations exist' do
      before do
        3.times { create(:organisation) }
        visit admin_organisations_path
      end

      it 'shows all three organisations' do
        Organisation.all.each do |org|
          expect(page).to have_content(org.name)
        end
      end
    end
  end
end
