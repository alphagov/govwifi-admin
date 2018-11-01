require 'features/support/not_signed_in'
require 'features/support/sign_up_helpers'
require 'support/notifications_service'
require 'support/confirmation_use_case'

describe "Locking a users account after too many failed login attempts" do
  include_examples 'confirmation use case spy'
  include_examples 'notifications service'

  after { Timecop.return }

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
      expect(page).to have_content 'Your account is locked.'
    end
  end

  context "after the user locks their accont" do
    it "unlocks the users account after one hour" do
      10.times do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: incorrect_password
        click_on 'Continue'
      end

      Timecop.freeze(Time.now + 61.minutes)

      fill_in 'Email', with: user.email
      fill_in 'Password', with: correct_password
      click_on 'Continue'
      expect(page).to have_content 'Signed in successfully.'
    end

    it "won't unlock their account if its under one hour" do
      10.times do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: incorrect_password
        click_on 'Continue'
      end

      Timecop.freeze(Time.now + 59.minutes)

      fill_in 'Email', with: user.email
      fill_in 'Password', with: correct_password
      click_on 'Continue'
      expect(page).to have_content 'Your account is locked.'
    end
  end
end
