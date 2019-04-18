require 'support/notifications_service'
require 'support/confirmation_use_case_spy'
require 'support/confirmation_use_case'

describe 'Resending confirmation instructions', type: :feature do
  let(:unconfirmed_email) { 'user@gov.uk' }

  include_context 'when sending a confirmation email'
  include_context 'when using the notifications service'

  context 'when entering an email address that has signed up but not confirmed' do
    before do
      sign_up_for_account(email: unconfirmed_email)
      visit new_user_confirmation_path
      fill_in 'user_email', with: unconfirmed_email
    end

    it 'resends the confirmation link' do
      expect {
        click_on 'Resend confirmation instructions'
      }.to change(ConfirmationUseCaseSpy, :confirmations_count).by(1)
    end

    it 'displays generic response message to the user' do
      click_on 'Resend confirmation instructions'
      expect(page).to have_content 'If your email address exists in our database, you will receive an email with instructions for how to confirm your email address in a few minutes.'
    end
  end

  context 'when comparing each link sent per request' do
    let(:previous_confirmation_link) { confirmation_email_link }

    before do
      sign_up_for_account(email: unconfirmed_email)
      visit new_user_confirmation_path
      fill_in 'user_email', with: unconfirmed_email
      click_on 'Resend confirmation instructions'
    end

    it 'does not change the link' do
      expect(confirmation_email_link).to eq(previous_confirmation_link)
    end
  end

  context 'when entering an email address that has NOT signed up' do
    let(:new_user_email) { 'different_user@gov.uk' }

    before do
      visit new_user_confirmation_path
      fill_in 'user_email', with: new_user_email
    end

    it 'displays a generic response to the user' do
      click_on 'Resend confirmation instructions'
      expect(page).to have_content 'If your email address exists in our database, you will receive an email with instructions for how to confirm your email address in a few minutes.'
    end

    it 'does not sent any confirmation link' do
      expect {
        click_on 'Resend confirmation instructions'
      }.to change(ConfirmationUseCaseSpy, :confirmations_count).by(0)
    end
  end

  context 'when email address has already been confirmed' do
    let(:user) { create(:user, email: unconfirmed_email) }
    let(:confirmed_email) { user.email }

    before do
      visit new_user_confirmation_path
      fill_in 'user_email', with: confirmed_email
    end

    it 'displays a generic response to the user' do
      click_on 'Resend confirmation instructions'
      expect(page).to have_content 'If your email address exists in our database, you will receive an email with instructions for how to confirm your email address in a few minutes.'
    end

    it 'does not sent any confirmation link' do
      expect {
        click_on 'Resend confirmation instructions'
      }.to change(ConfirmationUseCaseSpy, :confirmations_count).by(0)
    end
  end
end
