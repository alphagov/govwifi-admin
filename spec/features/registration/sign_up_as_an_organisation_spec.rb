require 'support/notifications_service'
require 'support/confirmation_use_case'

describe 'Sign up as an organisation', type: :feature do
  let(:name) { 'Sally' }

  before do
    Rails.application.config.s3_aws_config = {
      stub_responses: {
        get_object: { body: SIGNUP_WHITELIST_PREFIX_MATCHER + '(gov\.uk)$' }
      }
    }
  end

  include_context 'when sending a confirmation email'
  include_context 'when using the notifications service'

  context 'with a valid email' do
    let(:email) { 'newuser@gov.uk' }

    before { sign_up_for_account(email: email) }

    it 'instructs the user to check their confirmation email' do
      expect(page).to have_content(
        "A confirmation email has been sent to your email address."
        )
    end
  end

  context 'with correct data' do
    before do
      sign_up_for_account(email: email)
      update_user_details(name: name)
    end

    context 'with a gov.uk email' do
      let(:email) { 'someone@gov.uk' }

      it 'signs me in' do
        expect(page).to have_content 'Sign out'
      end

      it 'creates an organisation for the user' do
        expect(User.last.organisation.name).to eq('Gov Org 1')
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
        expect(page).to have_content("Email address must be from a government or a public sector domain. If you're having trouble signing up, contact us.")
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
        expect(page).to have_content("Email address must be from a government or a public sector domain. If you're having trouble signing up, contact us.")
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

  context 'when service email is not filled in' do
    before do
      sign_up_for_account
      update_user_details(service_email: "")
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

  context 'when an organisation is already registered' do
    let(:existing_org_name) { 'Gov Org 1' }

    before do
      sign_up_for_account
      create(:organisation, name: existing_org_name)
      update_user_details(organisation_name: existing_org_name)
    end

    it_behaves_like 'errors in form'

    it 'shows the user an error message' do
      within('div#error-summary')do
        expect(page).to have_content('Organisation name is already registered')
      end
    end

    it 'displays a contact us link' do
      within('div#error-summary')do
        expect(page).to have_link('Contact us', href: new_help_path)
      end
    end
  end

  context 'with an already registered email' do
    let(:email) { 'george@gov.uk' }

    before { sign_up_for_account(email: email) }

    it 'will tell the user the email is already in use' do
      sign_up_for_account(email: email)
      expect(page).to have_content("Email is already associated with an account. If you can't sign in, reset your password")
    end
  end

  context 'when no organisation has been selected' do
    let(:org_name_left_blank) { '' }

    before { sign_up_for_account }

    it 'displays one error message that the name cannot be left blank' do
      update_user_details(organisation_name: org_name_left_blank)
      within('div#error-summary') do
        expect(page).to have_selector("li#error-message", count: 1, text: "Organisation name can't be blank")
      end
    end
  end
end
