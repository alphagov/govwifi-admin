RSpec.feature "Signup Process" do
  context "as an Organisation" do
    it "should direct the user through the flow" do
      visit "/users/sign_up"
      fill_in("Email", :with => "tom@tom.com")

      expect do
        click_on "Sign up"
      end.to change { User.count }.by(1)
    end
  end

  context "confirmation page" do
    it "should display the correct page" do
      visit "/signup/confirmation"

      expect(page).to have_css("h1.govuk-heading-xl", text: "Super")
    end
  end
end
