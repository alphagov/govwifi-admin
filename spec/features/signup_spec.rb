RSpec.feature "Signup Process" do
  context "as an Organisation" do
    it "should direct the user through the flow" do
      visit "/signup/start"
      expect(page).to have_css("h1.govuk-heading-xl", text: "For Users")
      expect(page).to have_css("h1.govuk-heading-xl", text: "For Teams")
    end
  end
end
