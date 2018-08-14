require 'features/support/not_signed_in'
require 'features/support/sign_up_helpers'
require 'features/support/activation_notice'
require 'support/notifications_service'
require 'support/confirmation_use_case'

describe 'Add an IP to my account' do
  include_examples 'confirmation use case spy'
  include_examples 'notifications service'

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

    context 'before saving the IP' do
      it_behaves_like 'shows activation notice'

      it 'displays the form' do
        expect(page).to have_content('Add an IP')
      end
    end

    context 'after successfully saving an IP' do
      before do
        fill_in 'address', with: '123213213'
        expect { click_on 'save' }.to change { Ip.count }.by 1
      end

      it_behaves_like 'shows activation notice'

      it 'shows the successful confirmation page' do
        expect(Ip.first.user).to eq(user)
        expect(page).to have_content('IP Added')
        expect(page).to have_content(Ip.first.address)
        expect(page).to have_content(user.radius_secret_key)
      end
    end
  end
end
