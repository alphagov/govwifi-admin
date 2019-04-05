require 'support/invite_use_case'
require 'support/notifications_service'

describe "Inviting a team member as a super admin", type: :feature do
  let(:organisation) { create(:organisation, name: "Gov Org 3") }
  let(:super_admin) { create(:user, :super_admin) }
  let(:email) { 'barry@gov.uk' }

  before do
    sign_in_user super_admin
    visit admin_organisation_path(organisation)
    click_on 'Add team member'
    fill_in 'Email address', with: email
  end

  include_context 'when using the notifications service'
  include_examples 'invite use case spy'

  it "will take the user to the organisation when they click 'back to organisation'" do
    click_on 'Back to organisation'
    expect(page).to have_current_path(admin_organisation_path(organisation))
  end

  it "will display the name of the organisation you want to add a team member to" do
    expect(page).to have_content("Invite a team member to #{organisation.name}")
  end

  it "creates the user when invited" do
    expect { click_on 'Send invitation email' }.to change(User, :count).by(1)
  end

  it "adds the invited user to the correct organisation" do
    click_on 'Send invitation email'
    user = User.find_by(email: 'barry@gov.uk')
    expect(user.organisation).to eq(organisation)
  end

  it "will redirect the user to the organisation page on success" do
    click_on 'Send invitation email'
    expect(page).to have_current_path(admin_organisation_path(organisation))
  end

  context "without an email address" do
    let(:email) { "" }

    before do
      click_on 'Send invitation email'
    end

    it "does not send an invite" do
      expect(InviteUseCaseSpy.invite_count).to eq(0)
    end

    it "displays the correct error message" do
      expect(page).to have_content("Email can't be blank")
    end

    context "when retrying with a valid email address" do
      let(:email_second_attempt) { "barry@gov.uk" }

      before do
        fill_in 'Email address', with: email_second_attempt
        click_on 'Send invitation email'
      end

      it "sends an invite" do
        expect(InviteUseCaseSpy.invite_count).to eq(1)
      end

      it "adds the invited user to the correct organisation" do
        user = User.find_by(email: 'barry@gov.uk')
        expect(user.organisation).to eq(organisation)
      end

      it "will redirect the user to the organisation page on success" do
        expect(page).to have_current_path(admin_organisation_path(organisation))
      end
    end
  end
end
