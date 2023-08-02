describe "Wifi Admin Searches", type: :feature do
  let(:user) { create(:user, :super_admin, name: "super_admin") }

  before do
    sign_in_user user
    visit super_admin_wifi_admin_search_path
  end

  it "Has a link to download the list of admins" do
    allow(User).to receive(:admin_usage_csv)
    expect(page).to have_link("Download all admin data in CSV format")
    click_on "Download all admin data in CSV format"
    expect(User).to have_received(:admin_usage_csv)
  end

  it "Cannot find a user that does not exist" do
    fill_in "Admin name or email address", with: "bob"
    click_on "Find admin details"

    expect(page).to have_content("Nothing found for 'bob'")
  end

  context "With an admin user" do
    let(:admin_user) { build(:user) }
    let(:name) { admin_user.name }
    let(:email) { admin_user.email }
    before do
      admin_user.save!
      fill_in "Admin name or email address", with: search_term
      click_on "Find admin details"
    end
    describe "find by name" do
      let(:search_term) { name }
      it "Finds an admin user by name" do
        expect(page).to have_content("User details for '#{name}'")
      end
    end
    describe "find by email" do
      let(:search_term) { email }
      it "Finds an admin user by email address" do
        expect(page).to have_content("User details for '#{email}'")
      end
    end
  end
end
