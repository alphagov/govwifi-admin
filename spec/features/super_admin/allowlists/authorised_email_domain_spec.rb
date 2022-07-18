describe "Authorising Email Domains", type: :feature do
  let(:prefix) { UseCases::Administrator::PublishEmailDomainsRegex::SIGNUP_ALLOWLIST_PREFIX_MATCHER }

  before do
    sign_in_user admin_user
    visit new_super_admin_allowlist_email_domain_path
  end

  let(:admin_user) { create(:user, :super_admin) }

  context "when allowlisting a domain" do
    before do
      fill_in "Name", with: some_domain
    end

    context "when adding a new domain" do
      let(:some_domain) { "gov.uk" }

      it "authorises a new domain" do
        expect { click_on "Save" }.to change(AuthorisedEmailDomain, :count).by(1)
      end

      it "displays a success message to the user" do
        click_on "Save"
        expect(page).to have_content("#{some_domain} authorised")
      end

      it "publishes the authorised domains regex to S3" do
        click_on "Save"
        regexp = Gateways::S3.new(**Gateways::S3::DOMAIN_REGEXP).read
        expect(regexp).to eq("#{prefix}(gov\\.uk)$")
      end
      it "publishes the list of domains to S3" do
        click_on "Save"
        domains = Gateways::S3.new(**Gateways::S3::DOMAIN_ALLOW_LIST).read
        expect(domains).to eq("---\n- gov.uk\n")
      end
    end

    context "when submitting a blank domain" do
      let(:some_domain) { "" }

      it "does not create the domain" do
        expect { click_on "Save" }.not_to(change(AuthorisedEmailDomain, :count))
      end

      it "displays an error to the user" do
        click_on "Save"
        expect(page).to have_content("Name can't be blank")
      end
    end

    context "when submitting an invalid domain" do
      let(:some_domain) { "invalid" }

      it "does not create the domain" do
        expect { click_on "Save" }.not_to(change(AuthorisedEmailDomain, :count))
      end

      it "displays an error to the user" do
        click_on "Save"
        expect(page).to have_content("Name is invalid")
      end
    end

    context "when deleting a allowlisted domain" do
      let(:some_domain) { "police.uk" }

      before do
        click_on "Save"
        click_on "Remove"
      end

      it "removes a domain" do
        expect { click_on "Yes, remove #{some_domain} from the allow list" }.to change(AuthorisedEmailDomain, :count).by(-1)
      end

      it "tells the user the domain has been removed" do
        click_on "Yes, remove #{some_domain} from the allow list"
        expect(page).to have_content("#{some_domain} has been deleted")
      end

      it "publishes an updated regex list of authorised domains to S3" do
        expect { click_on "Yes, remove #{some_domain} from the allow list" }.to change {
          Gateways::S3.new(**Gateways::S3::DOMAIN_REGEXP).read
        }.from("#{prefix}(police\\.uk)$").to("^$")
      end

      it "publishes an updated email domains list to S3" do
        expect { click_on "Yes, remove #{some_domain} from the allow list" }.to change {
          Gateways::S3.new(**Gateways::S3::DOMAIN_ALLOW_LIST).read
        }.from("---\n- police.uk\n").to("--- []\n")
      end
    end
  end

  context "when viewing a list of domains" do
    before do
      %w[a b c].each do |letter|
        create(:authorised_email_domain, name: "#{letter}gov.some.test.uk")
      end
      visit super_admin_allowlist_email_domains_path
    end

    it "displays the list of all domains in alphabetical order" do
      expect(page.body).to match(/agov.some.test.uk.*bgov.some.test.uk.*cgov.some.test.uk/m)
    end
  end

  context "without super admin privileges" do
    let(:normal_user) { create(:user, :with_organisation) }

    before do
      sign_in_user normal_user
      visit new_super_admin_allowlist_email_domain_path
    end

    it_behaves_like "shows the settings page"
  end

  context "when logged out" do
    before do
      sign_out
      visit new_super_admin_allowlist_email_domain_path
    end

    it_behaves_like "not signed in"
  end
end
