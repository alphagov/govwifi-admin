describe "Remove a location", type: :feature do
  let(:organisation) { create(:organisation) }
  let(:user) { create(:user, organisations: [organisation]) }
  let!(:location) { create(:location, organisation:) }

  before do
    sign_in_user user
  end

  context "with correct permissions" do
    before do
      visit ips_path
    end

    context "when location has no IPs" do
      before do
        click_on "Remove this location"
      end

      it "shows the remove location partial" do
        within(".govuk-error-summary") do
          expect(page).to have_button("Yes, remove this location")
        end
      end

      it "removes the location" do
        expect { click_on "Yes, remove this location" }.to change(Location, :count).by(-1)
      end

      it "displays the success message to the user" do
        click_on "Yes, remove this location"
        expect(page).to have_content("Successfully removed location #{location.address}")
      end

      it 'redirects to the "after location removed" path for analytics' do
        click_on "Yes, remove this location"
        expect(page).to have_current_path("/ips/removed/location")
      end
    end

    context "when the location has an IP" do
      before do
        create(:ip, location:)
      end

      it "does not show the remove location link" do
        expect(page).not_to have_content("Remove location")
      end
    end
  end

  context "with incorrect permissions" do
    before do
      user.membership_for(organisation).update!(can_manage_locations: false)
    end

    it "does not show the remove button" do
      visit ips_path
      within("table") do
        expect(page).not_to have_content("Remove location")
      end
    end

    context "when visiting the remove location page directly" do
      before do
        visit location_remove_path(location)
      end

      it "does not show the partial" do
        expect(page).not_to have_content("Are you sure you want to remove this location")
      end
    end
  end

  context "when you do not own the location" do
    let(:other_location) { create(:location, organisation: create(:organisation)) }

    before do
      visit location_remove_path(other_location)
    end

    it "does not show the partial" do
      expect(page).not_to have_content("Are you sure you want to remove this location")
    end
  end
end
