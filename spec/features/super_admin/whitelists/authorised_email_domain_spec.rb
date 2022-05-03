describe "Authorising Email Domains", type: :feature do
  before do
    sign_in_user admin_user
    visit new_super_admin_whitelist_email_domain_path
  end

  let(:admin_user) { create(:user, :super_admin) }

  context "when whitelisting a domain" do
    before do
      fill_in "Name", with: some_domain
    end

    context "when adding a new domain" do
      let(:some_domain) { "gov.uk" }
      let(:regex_gateway) { instance_spy(Gateways::S3) }
      let(:email_domains_gateway) { instance_spy(Gateways::S3) }
      let(:presenter) { instance_double(UseCases::Administrator::FormatEmailDomainsList) }
      let(:data) { instance_double(StringIO) }

      before do
        allow(Gateways::S3).to receive(:new).and_return(regex_gateway, email_domains_gateway)
      end

      it "authorises a new domain" do
        expect { click_on "Save" }.to change(AuthorisedEmailDomain, :count).by(1)
      end

      it "displays a success message to the user" do
        click_on "Save"
        expect(page).to have_content("#{some_domain} authorised")
      end

      it "publishes the authorised domains regex to S3" do
        click_on "Save"
        expect(regex_gateway).to have_received(:write).with(data: "#{SIGNUP_WHITELIST_PREFIX_MATCHER}(gov\\.uk)$")
      end

      it "publishes the list of domains to S3" do
        allow(UseCases::Administrator::FormatEmailDomainsList).to receive(:new).and_return(presenter)
        allow(presenter).to receive(:execute).and_return(data)
        click_on "Save"
        expect(email_domains_gateway).to have_received(:write).with(data:)
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

    context "when deleting a whitelisted domain" do
      let(:some_domain) { "police.uk" }
      let(:regex_gateway) { instance_spy(Gateways::S3) }
      let(:email_domains_gateway) { instance_spy(Gateways::S3) }
      let(:presenter) { instance_double(UseCases::Administrator::FormatEmailDomainsList) }
      let(:data) { instance_double(StringIO) }

      before do
        allow(Gateways::S3).to receive(:new).and_return(regex_gateway, email_domains_gateway)
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
        allow(Gateways::S3).to receive(:new).and_return(regex_gateway)
        click_on "Yes, remove #{some_domain} from the allow list"
        expect(regex_gateway).to have_received(:write).with(data: "^$")
      end

      it "publishes an updated email domains list to S3" do
        allow(UseCases::Administrator::FormatEmailDomainsList).to receive(:new).and_return(presenter)
        allow(presenter).to receive(:execute).and_return(data)
        click_on "Yes, remove #{some_domain} from the allow list"
        expect(email_domains_gateway).to have_received(:write).with(data:)
      end
    end
  end

  context "when viewing a list of domains" do
    before do
      %w[a b c].each do |letter|
        create(:authorised_email_domain, name: "#{letter}gov.some.test.uk")
      end
      visit super_admin_whitelist_email_domains_path
    end

    it "displays the list of all domains in alphabetical order" do
      expect(page.body).to match(/agov.some.test.uk.*bgov.some.test.uk.*cgov.some.test.uk/m)
    end
  end

  context "without super admin privileges" do
    let(:normal_user) { create(:user, :with_organisation) }

    before do
      sign_in_user normal_user
      visit new_super_admin_whitelist_email_domain_path
    end

    it_behaves_like "shows the settings page"
  end

  context "when logged out" do
    before do
      sign_out
      visit new_super_admin_whitelist_email_domain_path
    end

    it_behaves_like "not signed in"
  end
end
