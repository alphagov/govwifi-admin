describe 'guidance after sign in' do
  include_context 'with a mocked notifications client'

  let(:user) { create(:user) }
  before { sign_in_user user }

  context 'without locations' do
    before { visit root_path }

    it 'displays message to inform user to add IPs and locations' do
      expect(page).to have_content 'RADIUS secret keys will be generated'
    end
  end

  context 'with locations' do
    let!(:location) { create(:location, organisation: user.organisation) }
    before { visit root_path }

    it 'shows me the landing guidance' do
      expect(page).to have_content 'Get GovWifi'
      expect(page).to have_content 'If you have trouble setting up GovWifi,'
    end

    context 'and an IP, clicking on that IP' do
      let(:ip_address) { '141.0.149.130' }

      before do
        create(:ip, address: ip_address, location: location)
        visit setup_instructions_path
        click_on '1 IP'
      end

      it 'shows me the IP address' do
        expect(page).to have_content(ip_address)
      end
    end

    context 'and no IPs' do
      it 'shows me I can add new IPs' do
        click_on 'add the IPs'
        expect(page).to have_content('Enter IP address')
      end
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
end
