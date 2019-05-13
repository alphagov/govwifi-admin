describe 'Viewing IP addresses', type: :feature do
  include_context 'with a mocked notifications client'

  let(:user) { create(:user, :with_organisation) }

  context 'with no IPs' do
    before do
      sign_in_user user
    end

    it 'shows no IPs' do
      visit ips_path
      expect(page).to have_content 'You need to add the IPs of your authenticator(s)'
    end

    it 'redirects the user to the setting up page' do
      visit root_path

      within("#setup-header") do
        expect(page).to have_content("Get GovWifi access in your organisation")
      end
    end
  end

  context 'with IPs' do
    let(:location) { create(:location, organisation: user.organisations.first) }
    let!(:ip) { create(:ip, location: location) }

    before do
      sign_in_user user
      visit ips_path
    end

    it 'shows the RADIUS secret key' do
      expect(page).to have_content(location.radius_secret_key)
    end

    it 'shows the IP' do
      expect(page).to have_content(ip.address)
    end

    it 'shows the locations address' do
      expect(page).to have_content(location.address)
    end

    context 'with inactive IPs' do
      it 'labels the IP as inactive' do
        within("#ips-row-#{ip.id}") do
          expect(page).to have_content('Inactive (no traffic for the last 10 days)')
        end
      end
    end

    context 'with active IPs' do
      before do
        create(:session, start: Date.today, username: 'abc123', siteIP: ip.address)
        visit ips_path
      end

      it 'Does not label the IP as inactive' do
        within("#ips-row-#{ip.id}") do
          expect(page).not_to have_content('Inactive (no traffic for the last 10 days)')
        end
      end
    end
  end

  context 'when logged out' do
    before { visit ips_path }

    it_behaves_like 'not signed in'
  end
end
