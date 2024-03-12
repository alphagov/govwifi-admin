describe "Nominate user to sign the MOU", type: :feature do
  include EmailHelpers

  let(:organisation) { create(:organisation, latest_mou_version: 2.0, mou_version_change_date: Time.zone.today) }
  let(:user) { create(:user, organisations: [organisation]) }

  context "when a user clicks on the 'Sign the MOU' button" do
    before do
      sign_in_user user
      visit settings_path
      click_on "Sign the MOU"
    end

    it "displays a link to sign the MOU" do
      expect(page).to have_content("Sign the MOU")
    end

    context "when the user chooses to nominate someone to sign the MOU" do
      before do
        choose "nominate_user"
        click_button "Continue"
      end

      it "takes the user to the correct page" do
        expect(page).to have_current_path("/mous/choose_option")
      end

      it "provides information about nominating someone to sign the MOU" do
        expect(page).to have_content("Nominate someone from your organisation")
      end

      context "when sending the nomination invite" do
        let(:nominated_user_name) { "John Doe" }
        let(:nominated_user_email) { "JohnDoe@gov.uk" }
        let(:email_gateway) { spy }

        before do
          allow(Services).to receive(:email_gateway).and_return(email_gateway)
          fill_in "nominated_user_name", with: nominated_user_name
          fill_in "nominated_user_email", with: nominated_user_email
          click_button "Nominate"
        end

        it "sends a nomination invitation email to the nominated user" do
          it_sent_a_nomination_email_once
        end

        it "informs the user about the next steps" do
          expect(page).to have_content("What happens next")
        end

        it "creates a nomination record with the nominated user's details" do
          expect(Nomination.last).to have_attributes(
            nominated_user_name:,
            nominated_user_email:,
          )
        end
      end
    end
  end
end
