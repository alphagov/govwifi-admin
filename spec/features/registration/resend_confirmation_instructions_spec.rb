require 'support/notifications_service'
require 'support/confirmation_use_case_spy'
require 'support/confirmation_use_case'

describe 'Resending confirmation instructions', type: :feature do
  let(:correct_email) { 'user@gov.uk' }

  include_context 'when sending a confirmation email'
  include_context 'when using the notifications service'

  context 'when entering correct information' do
    let(:entered_email) { correct_email }

    before do
      sign_up_for_account(email: correct_email)
      visit new_user_confirmation_path
      fill_in 'user_email', with: entered_email
    end

    it 'resends the confirmation link' do
      expect {
        click_on 'Resend confirmation instructions'
      }.to change(ConfirmationUseCaseSpy, :confirmations_count).by(1)
    end
  end

  context 'when comparing links before and after resending' do
    let(:entered_email) { correct_email }

    before do
      sign_up_for_account(email: correct_email)
    end

    it 'does not change the link' do
      previous_link = confirmation_email_link
      visit new_user_confirmation_path
      fill_in 'user_email', with: entered_email
      click_on 'Resend confirmation instructions'
      expect(confirmation_email_link).to eq(previous_link)
    end
  end

  context 'when user has not been confirmed' do
    let(:entered_email) { correct_email }

    context 'when email cannot be found' do
      before do
        sign_up_for_account(email: correct_email)
        visit new_user_confirmation_path
        fill_in 'user_email', with: entered_email
        click_on 'Resend confirmation instructions'
      end

      let(:entered_email) { 'different_user@gov.uk' }

      it_behaves_like 'errors in form'

      it 'displays an error to the user' do
        expect(page).to have_content 'Email not found'
      end
    end
  end

  context 'when user has been confirmed' do
    before do
      sign_up_for_account(email: correct_email)
      update_user_details
      visit new_user_confirmation_path
      fill_in 'user_email', with: correct_email
      click_on 'Resend confirmation instructions'
    end

    it_behaves_like 'errors in form'

    it 'tells the user this email has already been confirmed' do
      expect(page).to have_content 'Email was already confirmed'
    end
  end
end
