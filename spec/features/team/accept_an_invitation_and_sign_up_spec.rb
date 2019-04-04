require 'support/invite_use_case_spy'
require 'support/invite_use_case'
require 'support/notifications_service'

describe "Sign up from invitation", type: :feature do
  let(:invited_user_email) { "invited@gov.uk" }
  let(:user) { create(:user) }

  include_examples 'invite use case spy'
  include_examples 'with notifications service'

  # rubocop:disable RSpec/HooksBeforeExamples
  before do
    sign_in_user user
    invite_user(invited_user_email)
    sign_out
  end
  # rubocop:enable RSpec/HooksBeforeExamples

  context "when following the invite link" do
    let(:invite_link) { InviteUseCaseSpy.last_invite_url }
    let(:invited_user) { User.find_by(email: invited_user_email) }

    before do
      visit invite_link
    end

    it "displays the sign up page" do
      expect(page).to have_content("Create your account")
    end

    context "when signing up as an invited user" do
      before do
        fill_in "Your name", with: "Ron Swanson"
        fill_in "Password", with: "password"
        click_on "Create my account"
      end

      it "confirms the user" do
        expect(invited_user.confirmed?).to eq(true)
      end

      it "sets the users name" do
        expect(invited_user.name).to eq("Ron Swanson")
      end
    end
  end
end
