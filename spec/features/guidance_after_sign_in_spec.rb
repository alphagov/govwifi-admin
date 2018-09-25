require 'features/support/sign_up_helpers'
require 'support/notifications_service'

describe 'guidance after sign in' do
  let(:user) { create(:user, :confirmed, :with_organisation) }
  let!(:location) { create(:location, organisation: user.organisation) }

  before do
    sign_in_user user
    visit root_path
  end

  context 'with locations' do
    it 'shows me the landing guidance' do
      expect(page).to have_content 'Get GovWifi'
      expect(page).to have_content 'Getting help'
    end

    it 'displays radius connection details' do
      expect(page).to have_content(location.radius_secret_key)
    end

    context 'with radius IPs in env-vars' do
      let(:radius_ip_1) { '111.111.111.111' }
      let(:radius_ip_2) { '121.121.121.121' }
      let(:radius_ip_3) { '131.131.131.131' }
      let(:radius_ip_4) { '141.141.141.141' }

      before do
        ENV['LONDON_RADIUS_IPS'] = "#{radius_ip_1},#{radius_ip_2}"
        ENV['DUBLIN_RADIUS_IPS'] = "#{radius_ip_3},#{radius_ip_4}"
      end

      it 'displays RADIUS settings' do
        expect(page).to have_content('RADIUS')
        expect(page).to have_content('London')
        expect(page).to have_content('Dublin')
      end

      it 'displays the correct IPs' do
        expect(page).to have_content(radius_ip_1)
        expect(page).to have_content(radius_ip_2)
        expect(page).to have_content(radius_ip_3)
        expect(page).to have_content(radius_ip_4)
      end
    end
  end

  context 'without locations' do 

  end
end
