describe 'Add an IP' do
  let!(:user) { create(:user) }

  before do
    sign_in_user user
  end

  context 'with .can_manage_locations permission' do
    before do
      user.permission.update!(can_manage_locations: true)
    end

    context 'visiting the add IP page directly' do
      before do
        visit new_ip_path
      end

      it 'does not redirect them to the homepage' do
        expect(page.current_path).to eq(new_ip_path)
      end
    end

    it 'displays the add new IP link' do
      visit ips_path
      expect(page).to have_link('Add IP address')
    end

    context 'Homepage instructions' do
      before do
        Ip.delete_all
      end

      it 'has a link to add new IP addresses' do
        visit root_path
        expect(page).to have_link('add the IPs')
      end
    end
  end

  context 'without .can_manage_locations permission' do
    before do
      user.permission.update!(can_manage_locations: false)
    end

    it 'hides the add new IP link' do
      visit ips_path
      expect(page).to_not have_link('Add IP address')
    end

    context 'visiting the add IP page directly' do
      before do
        visit new_ip_path
      end

      it 'redirects them to the homepage' do
        expect(page.current_path).to eq(setup_index_path)
      end
    end

    context 'Homepage instructions' do
      before do
        Ip.delete_all
      end

      it 'has a link to add new IP addresses' do
        visit root_path
        expect(page).to_not have_link('add the IPs')
      end
    end
  end
end
