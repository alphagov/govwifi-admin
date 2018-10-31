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

  before do
    sign_up_for_account(email: 'george@gov.uk')
    update_user_details(
      password: correct_password,
      confirmed_password: correct_password
    )
    click_on 'Sign out'
  end

  it "warns the user they have one attmept left before locking the account" do
    9.times do
      fill_in 'Email', with: 'george@gov.uk'
      fill_in 'Password', with: incorrect_password
      click_on 'Continue'
    end
    expect(page).to have_content 'You have one more attempt before your account is locked.'
  end

  it "locks the users account after ten failed attempts" do
    10.times do
      fill_in 'Email', with: 'george@gov.uk'
      fill_in 'Password', with: incorrect_password
      click_on 'Continue'
    end
    expect(page).to have_content 'Your account is locked.'
  end

  it "unlocks the users account after one hour" do
    10.times do
      fill_in 'Email', with: 'george@gov.uk'
      fill_in 'Password', with: incorrect_password
      click_on 'Continue'
    end

    Timecop.freeze(Time.now + 1.hour)

    fill_in 'Email', with: 'george@gov.uk'
    fill_in 'Password', with: correct_password
    click_on 'Continue'
    expect(page).to have_content 'Signed in successfully.'
  end
end


