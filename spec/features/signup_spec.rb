RSpec.feature "Signup Process" do
  context "as an Organisation" do
    it "should direct the user through the flow" do
      visit "/signup/start"

      expect(page).to have_css("h1.govuk-heading-xl", text: "For Users")
      expect(page).to have_css("h1.govuk-heading-xl", text: "For Teams")
      expect(page).to have_css("a.govuk-button", text: "How to Sign Up")
      expect(page).to have_css("a.govuk-button", text: "Sign up Organisation")
      expect(page).to have_css("a", text: "Login")
      expect(page).to have_css("h2.govuk-heading-l", text: "What is GovWifi?")
      expect(page).to have_css("h2.govuk-heading-l", text: "Benefits")
      expect(page).to have_css("h2.govuk-heading-l", text: "How it works")

      click_on "Sign up Organisation"
      expect(page).to have_css("h1.govuk-heading-xl", text: "Welcome!")
      expect(page).to have_css("input.govuk-input#email")
      expect(page).to have_css("a.govuk-button", text: "Sign Up for Trial")
    end
  end

  context "confirmation page" do
    it "should display the correct page" do
      visit "/signup/confirmation"

      expect(page).to have_css("h1.govuk-heading-xl", text: "Super")
    end
  end
end
