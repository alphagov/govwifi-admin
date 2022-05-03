describe "Whitelisting an organisation", type: :feature do
  before do
    sign_in_user create(:user, :super_admin)
    visit new_super_admin_whitelist_path
  end

  it "displays the start page" do
    expect(page).to have_content("Give an organisation access to GovWifi")
  end

  it "allows the user to see the list of whitelisted organisations" do
    click_on "Organisations allow list"
    expect(page).to have_content("Custom Organisations that are already in our register")
  end

  it "allows the user to see the list of whitelisted email domains" do
    click_on "Email domains allow list"
    expect(page).to have_content("Email domains allow list")
  end

  context "when stepping through the setup steps" do
    it "displays the second step" do
      click_on "Start"
      expect(page).to have_content("Does the organisation need to create a GovWifi admin account?")
    end

    it "displays the third step" do
      click_on "Start"
      click_on "Yes"
      expect(page).to have_content("Is the organisation's name on the register?")
    end

    it "displays the fourth step" do
      click_on "Start"
      click_on "Yes"
      click_on "No"
      expect(page).to have_content("Add the organisation name to the register")
    end

    it "displays the fifth step" do
      click_on "Start"
      click_on "Yes"
      click_on "No"
      click_on "Continue"
      expect(page).to have_content("Add the organisation's email domain to the allow list")
    end
  end

  context "when validating the form input" do
    context "with an incorrect organisation name" do
      let(:organisation_name) { "Made Tech Ltd" }

      before do
        CustomOrganisationName.create!(name: organisation_name)
        visit new_super_admin_whitelist_path(whitelist: { step: Whitelist::FOURTH })
        fill_in "Organisation name", with: organisation_name
        click_on "Continue"
      end

      it "rerenders the organisation name form" do
        expect(page).to have_content("Add the organisation name to the register")
      end

      it "displays an error message to the user" do
        expect(page).to have_content("Name is already in our register").twice
      end
    end

    context "with incorrect email domain" do
      let(:email_domain) { "madetech.com" }

      before do
        AuthorisedEmailDomain.create!(name: email_domain)
        visit new_super_admin_whitelist_path(
          whitelist: {
            step: Whitelist::FIFTH,
            organisation_name: "Made Tech Limited",
          },
        )
        fill_in "Email domain", with: email_domain
        click_on "Continue"
      end

      it "rerenders the email domain form" do
        expect(page).to have_content("Add the organisation's email domain to the allow list")
      end

      it "displays an error message to the user" do
        expect(page).to have_content("Name has already been taken").twice
      end
    end
  end

  context "when saving the results of the setup process" do
    context "with all correct data" do
      before do
        visit new_super_admin_whitelist_path(
          whitelist: {
            step: Whitelist::FIFTH,
            organisation_name: "Made Tech Limited",
          },
        )
        fill_in "Email domain", with: "madetech.com"
        click_on "Continue"
      end

      it "saves the entered details" do
        expect { click_on "Submit" }.to change(CustomOrganisationName, :count).by(1)
          .and change(AuthorisedEmailDomain, :count).by(1)
      end

      it "displays a success message to the user" do
        click_on "Submit"
        expect(page).to have_content("Organisation has been added to the allow list")
      end
    end

    context "without an organisation name" do
      before do
        visit new_super_admin_whitelist_path(
          whitelist: {
            step: Whitelist::FIFTH,
            organisation_name: "",
          },
        )
        fill_in "Email domain", with: "madetech.com"
        click_on "Continue"
      end

      it "saves the entered details" do
        expect { click_on "Submit" }.to change(CustomOrganisationName, :count).by(0)
          .and change(AuthorisedEmailDomain, :count).by(1)
      end

      it "displays a success message to the user" do
        click_on "Submit"
        expect(page).to have_content("Organisation has been added to the allow list")
      end
    end

    context "without an email domain" do
      before do
        visit new_super_admin_whitelist_path(
          whitelist: {
            step: Whitelist::FIFTH,
            organisation_name: "Made Tech",
          },
        )
        fill_in "Email domain", with: ""
        click_on "Continue"
      end

      it "saves the entered details" do
        expect { click_on "Submit" }.to change(CustomOrganisationName, :count).by(1)
          .and change(AuthorisedEmailDomain, :count).by(0)
      end

      it "displays a success message to the user" do
        click_on "Submit"
        expect(page).to have_content("Organisation has been added to the allow list")
      end
    end

    context "when viewing the summary step" do
      before do
        visit new_super_admin_whitelist_path(
          whitelist: {
            step: Whitelist::SIXTH,
            organisation_name: "Made Tech",
            email_domain: "madetech.com",
          },
        )
      end

      it "displays all the organisation name" do
        expect(page).to have_content("Made Tech")
      end

      it "displays the email domain" do
        expect(page).to have_content("madetech.com")
      end
    end
  end
end
