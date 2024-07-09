describe "Nominate user to sign the MOU", type: :feature do
  include EmailHelpers

  let(:organisation) { create(:organisation) }
  let(:user) { create(:user, :with_organisation) }

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
        expect(page).to have_current_path(new_nomination_path)
      end

      it "provides information about nominating someone to sign the MOU" do
        expect(page).to have_content("Nominate someone from your organisation")
      end

      context "when sending the nomination invite" do
        let(:name) { "John Doe" }
        let(:email) { "JohnDoe@gov.uk" }
        let(:notify_gateway) { spy }

        before do
          allow(Services).to receive(:notify_gateway).and_return(notify_gateway)
          fill_in "Name", with: name
          fill_in "Email", with: email
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
            name:,
            email:,
          )
        end
      end
    end
  end
end
