require 'features/support/not_signed_in'
require 'features/support/sign_up_helpers'

describe 'View team mebers of my organisation' do
  context 'when logged out' do
    before do
      visit ips_path
    end

    it_behaves_like 'not signed in'
  end

  context 'when logged in' do
    let(:organisation) { create(:organisation) }
    let(:user) { create(:user, :confirmed, email: 'me@example.gov.uk', organisation: organisation) }

    before do
      ENV['LONDON_RADIUS_IPS'] = "1.1.1.1,2.2.2.2"
      ENV['DUBLIN_RADIUS_IPS'] = "1.1.1.1,2.2.2.2"
    end

    context 'when user is the only in the organisation' do
      it 'renders only the user' do
        sign_in_user user
        visit ips_path

        expect(page).to have_content('me@example.gov.uk')
      end
    end

    context 'when there are many users in the organisation' do
      before do
        create(:user, :confirmed, email: 'friend@example.gov.uk', organisation: organisation)
      end

      it 'renders all users within my organisation' do
        sign_in_user user
        visit ips_path

        expect(page).to have_content('me@example.gov.uk')
        expect(page).to have_content('friend@example.gov.uk')
      end
    end

    context 'when there are users outside of the organisation' do
      before do
        other_organisation = create(:organisation, name: 'Org 2')
        create(:user, :confirmed, email: 'stranger@example.gov.uk', organisation: other_organisation)
      end

      it 'does not include users from other organisations' do
        sign_in_user user
        visit ips_path

        expect(page).to_not have_content('stranger@example.gov.uk')
      end
    end
  end
end
