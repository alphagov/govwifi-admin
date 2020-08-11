require "support/notifications_service"
require "support/confirmation_use_case"

describe "Logging in after signing up", type: :feature do
  let(:correct_password) { "f1uffy-bu44ies!~plant" }

  include_context "when sending a confirmation email"
  include_context "when using the notifications service"

  before do
    allow(Rails.application.config).to receive(:enable_enhanced_2fa_experience).and_return true

    @user = create(:user, :with_organisation,
                   email: "tom@gov.uk",
                   password: correct_password,
                   name: "tom")
    @user.confirm
  end

  def signin(password)
    visit "/"

    fill_in "Email", with: "tom@gov.uk"
    fill_in "Password", with: password

    click_on "Continue"
  end

  context "with correct password" do
    it "signs me in" do
      signin(correct_password)
      expect(page).to have_content "Sign out"
    end
  end

  context "with incorrect password" do
    let(:incorrect_password) { "coarse" }

    before :each do
      signin(incorrect_password)
    end

    it_behaves_like "not signed in"

    it "displays an error to the user" do
      expect(page).to have_content "Invalid Email or password"
    end
  end

  context "email 2fa has been setup" do
    before :each do
      @user.update(second_factor_method: "email")
      @user.create_direct_otp
    end

    it "sends an email" do
      signin(correct_password)
      expect(notification_instance).to have_received(:send_email)
    end
  end
end
