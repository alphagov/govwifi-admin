require 'support/unlock_account_use_case_spy'
require 'support/unlock_account_use_case'

describe "Locking a users account after too many failed login attempts" do
  include_examples 'notifications service'

  let(:correct_password) { 'password' }
  let(:incorrect_password) { 'incorrectpassword' }
  let(:user) { create(:user, :confirmed, password: correct_password, password_confirmation: correct_password) }

  before { visit new_user_session_path }

  context "before the user locks their account" do
    it "warns the user they have one attmept left before locking the account" do
      9.times do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: incorrect_password
        click_on 'Continue'
      end
      expect(page).to have_content 'You have one more attempt before your account is locked.'
    end

    it "locks the users account after ten failed attempts" do
      10.times do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: incorrect_password
        click_on 'Continue'
      end
      expect(page).to have_content 'Your account has been locked. Reset your password'
    end

    it "locks the users account after ten failed attempts and sends an email" do
      allow(UseCases::Administrator::UnlockAccountEmail).to receive(:new).and_return(UnlockAccountUseCaseSpy.new)
      expect {
        10.times do
          fill_in 'Email', with: user.email
          fill_in 'Password', with: incorrect_password
          click_on 'Continue'
        end
      }.to change { UnlockAccountUseCaseSpy.unlock_count }.by(1)
      expect(page).to have_content 'Your account has been locked. Reset your password'
    end
  end
end
