require 'features/support/sign_up_helpers'

describe 'Remove an IP' do
  let(:user) { create(:user, :confirmed) }
  let!(:location) { create(:location, organisation: user.organisation) }
  let!(:ip) { create(:ip, location: location) }

  before do
    sign_in_user user
  end

  context "with correct permissions" do
    before do
      visit ips_path
      click_on "Remove"
    end

    it "shows the remove IP page" do
      expect(page).to have_content("Remove an IP address")
      expect(page).to have_content(ip.address)
    end

    it "removes the IP" do
      expect { click_on "Yes, remove this IP" }.to change { Ip.count }.by(-1)

      expect(page).to have_content("Successfully removed IP address #{ip.address}")
      expect(page).to have_content("IP addresses")
    end
  end

  context "with incorrect permissions" do
    before do
      user.permission.update!(can_manage_locations: false)
    end

    it "does not show the remove button" do
      visit ips_path

      within("#ips-table") do
        expect(page).to_not have_content("Remove")
      end
    end

    context "when visiting the remove IP page directly" do
      before do
        visit ip_remove_path(ip)
      end

      it "does not show the page" do
        expect(page).to_not have_content("Remove an IP address")
      end
    end
  end
end
