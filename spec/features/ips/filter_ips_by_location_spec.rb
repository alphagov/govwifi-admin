describe 'filtering IP addresses by dynamic search', type: :feature do

  Capybara.app_host = "http://app:3000"

  before do
    create(:location, organisation: organisation, address: 'Apple Street')
    create(:location, organisation: organisation, address: 'Banana Road')
    create(:location, organisation: organisation, address: 'Citrus Lane')
    sign_in_user user
    visit ips_path
  end

  let!(:organisation) { create(:organisation) }

  let(:user) { create(:user, organisation: organisation) }

  context 'when user fills in the search bar', js: true do

    let(:filter_value) { 'b' }

    before { fill_in 'input#filterInput', with: filter_value }

    it 'goes to the IPs page' do
      expect(page).to have_current_path('/ips')
    end

    it 'displays Banana Road as it has the letter b in it' do
      expect(page).to have_content('Banana Road')
    end

    it 'does not display Apple Street' do
      expect(page).not_to have_content('Apple Street')
    end

    it 'does not display Citrus Lane' do
      expect(page).not_to have_content('Citrus Lane')
    end
  end
end
