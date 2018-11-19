require 'features/support/sign_up_helpers'

describe 'Remove an IP' do
  let!(:user) { create(:user, :confirmed) }
  let!(:location) { create(:location, organisation: user.organisation) }
  let!(:ip) { create(:ip, location: location) }

  context "with correct permissions" do
    before do
      sign_in_user user
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
end
