describe "Choosing how to filter", type: :feature do
  before do
    sign_in_user create(:user, :with_organisation)
    visit new_logs_search_path
  end

  context "with no filter chosen" do
    before { click_on "Go to search" }

    it_behaves_like "errors in form"
  end

  context "when changing URL parameters" do
    context "with no filter on results link" do
      before { visit logs_path }

      it "redirects me to choosing a filter" do
        expect(page).to have_content("How do you want to filter these logs?")
      end
    end

    context "with a location not in the user's organisation" do
      let(:other_location) { create(:location) }

      it "does not find the location" do
        expect {
          visit logs_path(location: other_location.id)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  context "when choosing filter by email or contact number" do
    context "with super admin permissions" do
      before do
        sign_in_user create(:user, :super_admin)
        visit new_logs_search_path
      end

      it "shows the option to filter by email" do
        expect(page).to have_selector "label", text: "Email address", exact_text: true
      end

      it "shows the option to filter by contact number" do
        expect(page).to have_selector "label", text: "Phone number", exact_text: true
      end
    end

    context "with admin permissions" do
      it "hides the options to filter by email" do
        expect(page).to_not have_selector "label", text: "Email address", exact_text: true
      end

      it "hides the options to filter by contact number" do
        expect(page).to_not have_selector "label", text: "Phone number", exact_text: true
      end
    end
  end
end
