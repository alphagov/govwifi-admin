describe 'Wiew whether IPs are ready', type: :feature do
  include_context 'with a mocked notifications client'

  context 'when one IP has been added' do
    let(:user) { create(:user) }

    before do
      create :location, organisation: user.organisation
      sign_in_user user
      visit new_ip_path(organisation: user.organisation.uuid)
      fill_in 'address', with: '141.0.149.130'
      click_on 'Add new IP address'
    end

    context 'when viewing the new IP immediately' do
      before { visit ips_path(organisation: user.organisation.uuid) }

      it 'shows it is activating tomorrow' do
        expect(page).to have_content('Not available until 6am tomorrow')
      end
    end

    context 'when viewing the IP after a day' do
      before do
        Ip.all.each do |ip|
          ip.update_attributes(created_at: Date.yesterday)
        end
        sign_in_user user
        visit ips_path(organisation: user.organisation.uuid)
      end

      it 'shows it as available' do
        expect(page).to have_content('Available')
      end

      it 'does not shpow any IPs as available tomorrow' do
        expect(page).not_to have_content('tomorrow')
      end
    end
  end
end
