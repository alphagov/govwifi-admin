RSpec.describe WifiUser do
  describe "search" do
    context "with username as search term" do
      before { create(:wifi_user, username: "CfxYtb") }

      it "finds a wifi user" do
        expect(described_class.search("CFXYTB")).not_to be_nil
      end
    end

    context "with contact details as search term" do
      before { create(:wifi_user, contact: "wifi.user@govwifi.org") }

      it "finds a wifi user" do
        expect(described_class.search("wIfI.uSEr@govWIFI.org")).not_to be_nil
      end
    end

    context "with only partial search term" do
      before do
        create(:wifi_user, contact: "wifi.user@govwifi.org")
        create(:wifi_user, username: "wifiname")
      end

      it "first finds a wifi user by similar contact" do
        found_user = described_class.search("wifi")
        expect(found_user).not_to be_nil
        expect(found_user.contact).to eq("wifi.user@govwifi.org")
      end

      it "then finds a wifi user by similar username" do
        found_user = described_class.search("name")
        expect(found_user).not_to be_nil
        expect(found_user.username).to eq("wifiname")
      end
    end
  end
end
