require 'features/support/not_signed_in'
require 'features/support/sign_up_helpers'

describe 'Add an IP to my account' do
  context 'when logged out' do
    before do
      visit new_ip_path
    end

    it_behaves_like 'not signed in'
  end

  context 'when logged in' do
    let(:user) { create(:user) }
    before do
      sign_in_user user
      visit ips_path
      expect(page).to have_content "Add IP"
      click_on "Add IP"
    end

    it 'displays the form' do
      expect(page).to have_content('Add an IP')
    end

    it 'creates the IP for the user' do
      fill_in 'address', with: '123213213'
      expect { click_on 'save' }.to change { Ip.count }.by 1

      expect(Ip.first.user).to eq(user)
      expect(page).to have_content('New IP Added!')
      expect(page).to have_content(Ip.last.address)
      expect(page).to have_content(user.radius_secret_key)
    end
  end
end
