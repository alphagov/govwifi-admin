describe "Wifi User Searches", type: :feature do
  include EmailHelpers
  let(:user) { create(:user, :super_admin, name: "super_admin") }
  let(:email_gateway) { spy }
  let(:search_term) { username }

  before do
    sign_in_user user
    visit super_admin_wifi_user_search_path
  end

  it "shows a page to search for wifi user details" do
    expect(page).to have_content("Search for user details")
  end

  it "Cannot find a user that does not exist" do
    fill_in "Username, email address or phone number", with: "bob"
    click_on "Find user details"
    expect(page).to have_content("Nothing found for 'bob'")
  end

  context "With a wifi user" do
    let!(:wifi_user) { create(:wifi_user, username: "bob", contact: "bob@govwifi.org") }
    let(:username) { "bob" }
    let(:contact) { "bob@govwifi.org" }

    before do
      fill_in "Username, email address or phone number", with: search_term
      click_on "Find user details"
    end

    describe "find by username" do
      it "Finds an admin user by name" do
        expect(page).to have_content("User details for '#{wifi_user.username}'")
      end
    end

    describe "find by contact" do
      it "Finds a wifi user by email address" do
        expect(page).to have_content("User details for '#{wifi_user.username}'")
      end
    end

    describe "deleting" do
      before do
        allow(Services).to receive(:email_gateway).and_return(email_gateway)
        click_on "Remove user"
      end

      it "ask for confirmation" do
        expect(page).to have_content("Confirm removing #{wifi_user.contact}")
      end

      it "triggers an email noitfying the user they have been removed from Govwifi" do
        click_on "Remove user"
        it_sent_a_notify_user_email_once
      end
    end

    context "With a wifi user with a phone number as contact" do
      let!(:wifi_user_with_phone_number) { create(:wifi_user, username: "alice", contact: "+447391490035") }
      let(:username) { "alice" }
      let(:contact) { "+447390012345" }

      before do
        fill_in "Username, email address or phone number", with: search_term
        click_on "Find user details"
        allow(Services).to receive(:email_gateway).and_return(email_gateway)
        click_on "Remove user"
      end

      it "asks for confirmation" do
        expect(page).to have_content("Confirm removing #{wifi_user_with_phone_number.contact}")
      end

      it "triggers an sms notifying the user they have been removed from Govwifi" do
        click_on "Remove user"
        it_sent_a_notify_user_sms_once
      end
    end
  end
end
