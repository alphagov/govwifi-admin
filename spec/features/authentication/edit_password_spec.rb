describe "Editing password", type: :feature do
  let(:user) { create(:user, :with_2fa, :with_organisation) }
  let(:pw) do
    Faker::Internet.password(
      min_length: 10,
      max_length: 20,
      mix_case: true,
      special_characters: true,
    )
  end

  before do
    sign_in_user user
  end

  it "offers a change password link in the settings panel" do
    visit root_path

    click_on "Settings"

    expect(page).to have_content "Change your password"
  end

  it "successfully updates the current user's password" do
    visit edit_user_registration_path

    fill_in "Current password", with: user.password
    fill_in "Password", with: pw
    fill_in "Password confirmation", with: pw

    click_on "Submit"

    expect(page).to have_content "Your account has been updated successfully."

    sign_out

    fill_in "Email", with: user.email
    fill_in "Password", with: pw

    click_on "Continue"

    expect(page).to have_content "Sign out"
  end

  it "stays on the same page and does not change the password, if the current password is invalid" do
    visit edit_user_registration_path

    fill_in "Current password", with: "wrong password"
    fill_in "Password", with: pw
    fill_in "Password confirmation", with: pw

    click_on "Submit"

    expect(page).to have_content "Current password is invalid"
    expect(page).to have_css "#user_current_password.govuk-input--error"
    expect(page).to have_css ".govuk-form-group.govuk-form-group--error"
  end

  it "stays on the same page and does not change the password, if the new password is too short" do
    visit edit_user_registration_path

    fill_in "Current password", with: user.password
    fill_in "Password", with: "a"
    fill_in "Password confirmation", with: "a"

    click_on "Submit"

    expect(page).to have_content "Password is too short"
    expect(page).to have_css "#user_password.govuk-input--error"
    expect(page).to have_css ".govuk-form-group.govuk-form-group--error"
  end

  it "stays on the same page and does not change the password, if the confirmation does not match" do
    visit edit_user_registration_path

    fill_in "Current password", with: user.password
    fill_in "Password", with: pw
    fill_in "Password confirmation", with: "different password"

    click_on "Submit"

    expect(page).to have_content "Password confirmation doesn't match Password"
    expect(page).to have_css "#user_password_confirmation.govuk-input--error"
    expect(page).to have_css ".govuk-form-group.govuk-form-group--error"
  end
end
