describe 'Guidance after sign in', type: :feature do
  include_context 'with a mocked notifications client'

  let(:user) { create(:user, :with_organisation) }

  before { sign_in_user user }

  context 'without locations' do
    before { visit root_path }

    it 'displays message to inform user to add IPs and locations' do
      expect(page).to have_content 'RADIUS secret keys will be generated'
    end
  end

  context 'with locations' do
    let!(:location) { create(:location, organisation: user.organisations.first) }

    before { visit root_path }

    it 'displays the landing guidance' do
      expect(page).to have_content 'Get GovWifi'
    end

    context 'with one IP' do
      let(:ip_address) { '141.0.149.130' }

      before do
        create(:ip, address: ip_address, location: location)
        visit setup_instructions_path
        click_on '1 IP'
      end

      it 'displays the IP address' do
        expect(page).to have_content(ip_address)
      end
    end

    context 'with no IPs' do
      it 'allows user to add new IPs' do
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

      it 'displays the London IPs' do
        ips = page.all(:css, '#london-radius-ips li').map(&:text)
        expect(ips).to match_array([radius_ip_1, radius_ip_2])
      end

      it 'displays the Dublin IPs' do
        ips = page.all(:css, '#dublin-radius-ips li').map(&:text)
        expect(ips).to match_array([radius_ip_3, radius_ip_4])
      end
    end
  end
end
