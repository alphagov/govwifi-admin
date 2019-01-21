require 'support/notifications_service'
require 'support/confirmation_use_case'
require 'support/fetch_organsiations'

describe 'Sign up as an organisation' do
  include_examples 'confirmation use case spy'
  include_examples 'notifications service'
  include_examples 'organisations register'

  let(:name) { 'Sally' }

  context 'with a valid email' do
    let(:email) { 'newuser@gov.uk' }
    before { sign_up_for_account(email: email) }

    it 'instructs the user to check their confirmation email' do
      expect(page).to have_content(
        "A confirmation email has been sent to #{email}"
        )
    end
  end

  context 'with correct data' do
    before do
      sign_up_for_account(email: email)
      update_user_details(name: name, organisation_name: "Parks & Recreation")
    end

    context 'with a gov.uk email' do
      let(:email) { 'someone@gov.uk' }

      it 'signs me in' do
        expect(page).to have_content 'Sign out'
      end

      it 'creates an organisation for the user' do
        expect(User.last.organisation.name).to eq("Parks & Recreation")
      end
    end

    context 'with a email from a subdomain of gov.uk' do
      let(:email) { 'someone@other.gov.uk' }

      it 'signs me in' do
        expect(page).to have_content 'Sign out'
      end
    end

    context 'with a non-gov email' do
      let(:email) { 'someone@google.com' }

      it 'tells me my email is not valid' do
        expect(page).to have_content("Only government organisations can sign up to GovWifi. If you're having trouble signing up, contact us.")
      end

      it 'provides a link to a support form' do
        visit new_user_registration_path
        click_on "Sign up"
        click_on "contact us"
        expect(page).to have_content("I'm having trouble signing up")
      end
    end

    context 'with a blank email' do
      let(:email) { '' }

      it 'tells me my email is not valid' do
        expect(page).to have_content("Only government organisations can sign up to GovWifi. If you're having trouble signing up, contact us.")
      end
    end

    context 'without a name' do
      let(:name) { '' }
      let(:email) { 'someone@other.gov.uk' }

      it 'tells me my name is not valid' do
        expect(page).to have_content("Name can't be blank")
      end
    end
  end

  context 'when password is too short' do
    before do
      sign_up_for_account
      update_user_details(password: '1')
      expect(page).to have_content 'Create your account'
    end

    it_behaves_like 'errors in form'

    it 'tells the user that the password is too short' do
      expect(page).to have_content 'Password is too short (minimum is 6 characters)'
    end
  end

  context 'without a password' do
    let(:email) { 'someone@gov.uk' }

    before do
      sign_up_for_account
      update_user_details(password: '')
    end

    it_behaves_like 'errors in form'

    it 'tells me my password is not valid' do
      expect(page).to have_content("Password can't be blank")
    end
  end

  context 'when Organisation name is taken' do
    let!(:existing_org) { create(:organisation) }

    before do
      sign_up_for_account
      update_user_details(organisation_name: existing_org.name)
      expect(page).to have_content 'Create your account'
    end

    it_behaves_like 'errors in form'

    it 'tells the user that the organisation name must be unique' do
      expect(page).to have_content 'Organisation name is already registered'
    end
  end

  context 'when service email is not filled in' do
    before do
      sign_up_for_account
      update_user_details(service_email: "")
      expect(page).to have_content 'Create your account'
    end

    it_behaves_like 'errors in form'

    it 'tells the user that the service email must be present' do
      expect(page).to have_content "Organisation service email can't be blank"
    end
  end

  context 'when password is too short' do
    before do
      sign_up_for_account
      update_user_details(password: '1')
      expect(page).to have_content 'Create your account'
    end

    it_behaves_like 'errors in form'

    it 'tells the user that the password is too short' do
      expect(page).to have_content 'Password is too short (minimum is 6 characters)'
    end
  end

  context 'when account is already confirmed' do
    before do
      sign_up_for_account
      update_user_details
      visit confirmation_email_link
    end

    it_behaves_like 'errors in form'

    it 'tells the user the email is already confirmed' do
      expect(page).to have_content 'Email was already confirmed'
    end
  end
end
