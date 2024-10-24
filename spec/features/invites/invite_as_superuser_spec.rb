describe "Inviting a team member as a super user", type: :feature do
  let(:super_admin) { create(:user, :super_admin) }
  let(:organisation) { create(:organisation) }
  include EmailHelpers

  before do
    create(:user, organisations: [organisation])
    sign_in_user super_admin
    visit "/"
    click_on "Assume Membership"
    click_on organisation.name
    click_on "Team members"
    click_on "Invite a team member"

    fill_in "Email", with: invited_user_email
    choose("Administrator")
    click_on "Send invitation email"
  end

  describe "Inviting a new team member who is not in the database" do
    let(:invited_user_email) { "correct@gov.uk" }
    let(:invited_user) { User.find_by(email: invited_user_email) }

    it "creates an unconfirmed user" do
      expect(invited_user).to be_present
    end
  end
end
