describe 'Add an IP', type: :feature do
  let(:organisation) { create(:organisation) }
  let(:user) { create(:user, organisations: [organisation]) }

  before do
    sign_in_user user
  end

  context 'with .can_manage_locations permission' do
    before do
      user.membership_for(organisation).update!(can_manage_locations: true)
    end

    context 'when visiting the add IP page directly' do
      before do
        visit new_ip_path
      end

      it 'does not redirect them to the homepage' do
        expect(page).to have_current_path(new_ip_path)
      end
    end

    it 'displays the add new IP link' do
      visit ips_path
      expect(page).to have_link('Add IP address')
    end

    context 'when viewing homepage instructions' do
      before do
        Ip.delete_all
      end

      it 'has a link to add new IP addresses' do
        visit root_path
        expect(page).to have_link('add the IP addresses')
      end
    end
  end

  context 'without .can_manage_locations permission' do
    before do
      user.membership_for(organisation).update!(can_manage_locations: false)
    end

    it 'hides the add new IP link' do
      visit ips_path
      expect(page).not_to have_link('Add IP address')
    end

    context 'when visiting the add IP page directly' do
      before do
        visit new_ip_path
      end

      it_behaves_like 'shows the setup instructions page'
    end

    context 'when viewing the homepage instructions' do
      before do
        Ip.delete_all
      end

      it 'has a link to add new IP addresses' do
        visit root_path
        expect(page).not_to have_link('add the IPs')
      end
    end
  end
end
