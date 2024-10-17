describe "Inviting a user to their second or subsequent organisation", type: :feature do
  include EmailHelpers

  let(:betty_organisation) { create(:organisation) }
  let(:betty) { create(:user, organisations: [betty_organisation]) }
  let(:confirmed_user) { create(:user, :with_organisation) }

  context "with a confirmed user" do
    before do
      sign_in_user confirmed_user
      visit new_user_invitation_path
      fill_in "Email", with: betty.email
      choose "Administrator"
      click_on "Send invitation email"
    end

    it "sends a membership invitation" do
      it_sent_a_cross_organisational_invitation_email
    end

    it "does not send a new user invite" do
      it_did_not_send_an_invitation_email
    end

    it "creates a join organisation invitation" do
      expect(betty.memberships.count).to eq(2)
    end

    it "notifies the user with a success message" do
      expect(page).to have_content("#{betty.email} has been invited to join #{confirmed_user.organisations.first.name}")
    end

    context "when the invited user signs in aftwards" do
      before do
        sign_out
        sign_in_user betty
        visit confirm_new_membership_url(token: betty.membership_for(betty_organisation).invitation_token)
      end

      it "changes your current organisation to this organisation" do
        within(".govuk-header") do
          expect(page.html).to include(betty_organisation.name)
        end
      end
    end
  end

  context "with an unconfirmed user" do
    let(:unconfirmed_email) { "notconfirmedyet@gov.uk" }

    before do
      sign_up_for_account(email: unconfirmed_email)
      sign_in_user confirmed_user
      visit new_user_invitation_path
      fill_in "Email", with: unconfirmed_email
      choose "Administrator"
      click_on "Send invitation email"
    end

    it "sends an invitation" do
      it_sent_an_invitation_email_once
    end
  end
end
