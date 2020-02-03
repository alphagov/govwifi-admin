describe "Editing password", type: :feature do
  let(:user) { create(:user, :with_2fa, :with_organisation) }
  let(:pw) { Faker::Internet.password }

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

    sign_out

    fill_in "Email", with: user.email
    fill_in "Password", with: pw

    click_on "Continue"

    expect(page).to have_content "Sign out"
  end
end
