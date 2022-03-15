require "timecop"

describe "Logout users after period of inactivity", type: :feature do
  let(:user) { create(:user, :with_organisation) }

  context "when a signed in user has been inactive for 29 minutes" do
    before do
      sign_in_user user
      visit root_path
      Timecop.travel(Time.zone.now + 29.minutes) { visit root_path }
    end

    after { Timecop.return }

    it "and they navigate to a page" do
      visit memberships_path

      expect(page).to have_content("Invite a team member")
    end
  end

  context "when a signed in user has been inactive for half an hour" do
    before do
      sign_in_user user
      visit root_path
      Timecop.travel(Time.zone.now + 30.minutes) { visit root_path }
    end

    after { Timecop.return }

    it_behaves_like "not signed in"

    it "and they navigate to a page after signing in again" do
      sign_in_user user
      visit memberships_path

      expect(page).to have_content("Invite a team member")
    end
  end
end
