describe 'Removing an IP', type: :feature do
  let(:user) { create(:user) }
  let(:location) { create(:location, organisation: user.organisation) }
  let!(:ip) { create(:ip, location: location) }

  before do
    sign_in_user user
  end

  context "with correct permissions" do
    before do
      visit ips_path(organisation: user.organisation.uuid)
      click_on "Remove"
    end

    it "shows the remove IP partial" do
      within(".govuk-error-summary") do
        expect(page).to have_content(ip.address)
      end
    end

    it "shows the remove IP button" do
      within(".govuk-error-summary") do
        expect(page).to have_button("Yes, remove this IP")
      end
    end

    it "removes the IP" do
      expect { click_on "Yes, remove this IP" }.to change(Ip, :count).by(-1)
    end

    it "displays the success message to the user" do
      click_on "Yes, remove this IP"
      expect(page).to have_content("Successfully removed IP address #{ip.address}")
    end

    it 'redirects to the "after IP removed" path for Analytics' do
      click_on "Yes, remove this IP"
      expect(page).to have_current_path("/organisations/#{user.organisation.uuid}/ips/removed")
    end
  end

  context "with incorrect permissions" do
    before do
      user.permission.update!(can_manage_locations: false)
    end

    it "does not show the remove button" do
      visit ips_path(organisation: user.organisation.uuid)

      within("#ips-table") do
        expect(page).not_to have_content("Remove")
      end
    end

    context "when visiting the remove IP page directly" do
      before do
        visit ip_remove_path(ip, organisation: user.organisation.uuid)
      end

      it "does not show the partial" do
        expect(page).not_to have_content("Are you sure you want to remove this IP")
      end
    end
  end

  context "when you do not own the IP" do
    let(:other_ip) { create(:ip, location: create(:location)) }

    before do
      visit ip_remove_path(other_ip, organisation: user.organisation.uuid)
    end

    it "does not show the partial" do
      expect(page).not_to have_content("Are you sure you want to remove this IP")
    end
  end
end
