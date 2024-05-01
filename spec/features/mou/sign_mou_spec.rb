describe "Sign MOU", type: :feature do
  include EmailHelpers

  let(:organisation) { create(:organisation) }
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

    context "when the user chooses to sign the MOU themselves" do
      before do
        choose "sign_mou"
        click_button "Continue"
      end

      it "navigates the user to the MOU signing page" do
        expect(page).to have_current_path("/mous/choose_option")
      end

      it "pre-fills the user's name and email in the form" do
        expect(find_field("Name").value).to eq user.name
        expect(find_field("Email").value).to eq user.email
      end

      it "displays an unchecked checkbox for accepting the terms" do
        expect(page).to have_field("mou[signed]", type: "checkbox", visible: true, checked: false)
      end

      it "allows the user to specify their job role" do
        fill_in "mou[job_role]", with: "Software Developer"
      end

      context "when submitting the MOU form" do
        let(:email_gateway) { spy }
        let(:signed_date) { Time.zone.today.strftime("%-d %B %Y") }

        before do
          allow(Services).to receive(:email_gateway).and_return(email_gateway)
          fill_in "Job role", with: "Software Developer"
          check "I confirm that I have the authority to accept these terms and that #{organisation.name} will be bound by them."
          click_button "Accept the MOU"
        end

        it "sends a MOU signed confirmaton email" do
          it_sent_a_thank_you_for_signing_the_mou_email_once
        end

        it "saves the users information to the MOU" do
          expect(Mou.last.job_role).to eq "Software Developer"
        end

        it "displays a button to review the MOU on the settings page after MOU creation" do
          expect(page).to have_link("Review")
        end

        it "redirects the user to the settings page after MOU creation" do
          expect(page).to have_current_path(settings_path)
        end

        it "displays a notification after MOU creation" do
          expect(page).to have_content("Memorandum of understanding (MOU) Signed by #{user.name} on #{signed_date}")
        end
      end

      context "when the user fails to sign the MOU" do
        before do
          click_button "Accept the MOU"
        end

        it "displays an error messages to show validation errors" do
          expect(page).to have_content("There is a problem\nJob role can't be blank. You must accept the terms to sign the MOU")
        end
      end
    end
  end
end
