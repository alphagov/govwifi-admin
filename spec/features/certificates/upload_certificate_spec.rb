describe "Upload Certificate", type: :feature do
  let(:organisation) { create(:organisation, :with_cba_enabled) }
  let(:user) { create(:user, organisations: [organisation]) }
  let(:not_after) { Time.zone.now.days_since(365) }
  let(:not_before) { Time.zone.now.days_ago(1) }

  let(:root_ca) { CertificateHelper.new.root_ca(not_after:, not_before:) }
  let(:intermediate_ca) { CertificateHelper.new.intermediate_ca(signed_by: root_ca) }
  let(:root_certificate_path) do
    file = Tempfile.new("certificate_file")
    file.write(root_ca.to_pem)
    file.close
    file.path
  end

  let(:intermediate_certificate_path) do
    file = Tempfile.new("certificate_file")
    file.write(intermediate_ca.to_pem)
    file.close
    file.path
  end

  before do
    sign_in_user user
  end

  context "when organisation is not enabled for cba" do
    let(:organisation) { create(:organisation) }
    before do
      visit root_path
    end

    it "does not display the Certificates link on the left nav" do
      expect(page.find(".leftnav")).to_not have_content("Certificates")
    end
  end

  context "when organisation is enabled for cba" do
    before do
      visit root_path
    end

    it "displays the Certificates link on the left nav" do
      expect(page.find(".leftnav")).to have_content("Certificates")
    end

    it "takes you to the form to upload a certificate" do
      click_on "Certificates"
      expect(page).to have_link("Add Certificate")

      click_on "Add Certificate"
      expect(page).to have_content "Add Certificate"
    end
  end

  describe "when uploading a certificate without choosing a file" do
    before do
      visit new_certificate_path
    end

    it "reports an error" do
      fill_in "Name", with: "MyCert1"
      click_button "Upload Certificate"

      expect(page).to have_content "No Certificate file selected. Please choose a file to try again."
    end
  end

  describe "when uploading a certificate without setting a name" do
    before do
      visit new_certificate_path
    end

    it "reports an error" do
      attach_file("File", root_certificate_path)
      click_button "Upload Certificate"

      expect(page).to have_content "Certificate Name can't be blank"
    end
  end

  describe "when uploading a malformed certificate" do
    before do
      visit new_certificate_path
    end

    it "reports an error" do
      file = Tempfile.new("bad_cert")
      file.write("this is not a certificate")
      file.close

      fill_in "Name", with: "MyCert1"
      attach_file("File", Rails.root.join(file.path))
      click_button "Upload Certificate"

      file.unlink

      expect(page).to have_content "Certificates must be in a .PEM format"
    end
  end

  describe "when uploading a valid certificate" do
    let(:certificate_path) { root_certificate_path }
    before do
      visit new_certificate_path
    end
    before :each do
      fill_in "Name", with: "MyCert1"
      attach_file("File", certificate_path)
      click_button "Upload Certificate"
    end
    it "succeeds" do
      expect(page).to have_current_path(certificates_path)
      expect(page).to have_content("New Certificate Added")
    end
    it "lists the new certificate" do
      expect(page.find_link("MyCert1")).to_not be nil
    end
    it "indicates the certificate has not expired" do
      expect(page).to_not have_content("Expired")
    end
    it "indicates the certificate does not expire soon" do
      expect(page).to_not have_content("Expiring soon")
    end
    it "indicates the certificate is a root certificate" do
      expect(page).to have_content("Root")
      expect(page).to_not have_content("Intermediate")
    end
    context "upload an intermediate certificate" do
      let(:certificate_path) { intermediate_certificate_path }

      it "indicates the certificate is an intermediate certificate" do
        expect(page).to_not have_content("Root")
        expect(page).to have_content("Intermediate")
      end
    end
    context "the certificate has expired" do
      let(:not_after) { Time.zone.now.days_ago(1) }
      it "indicates the certificate has expired" do
        expect(page).to have_content("Expired")
      end
    end
    context "the certificate has nearly expired" do
      let(:not_after) { Time.zone.now.days_since(5) }
      it "indicates the certificate has nearly expired" do
        expect(page).to have_content("Expiring soon")
      end
    end
    context "the certificate is not yet valid" do
      let(:not_before) { Time.zone.now.days_since(5) }
      it "is not yet valid" do
        expect(page).to have_content("Not yet valid")
      end
    end
    it "is already valid" do
      expect(page).to_not have_content("Not yet valid")
    end
    context "the certificate was created today" do
      it "will be activated tomorrow" do
        visit(certificates_path)
        expect(page).to have_content("Available from 6am tomorrow")
      end
    end
    context "the certificate was created yesterday" do
      it "has already been activated" do
        Timecop.travel(Time.zone.now.days_since(1)) do
          visit(certificates_path)
          expect(page).to_not have_content("Available the following day")
        end
      end
    end
    context "show the certificate" do
      before :each do
        click_link "MyCert1"
      end
      it "shows the properties of the certificate" do
        expect(page).to have_content("Name MyCert1")
        expect(page).to have_content("Fingerprint #{OpenSSL::Digest::SHA1.new(root_ca.to_der)}")
        expect(page).to have_content("Serial #{root_ca.serial}")
        expect(page).to have_content("Valid From #{root_ca.not_before}")
        expect(page).to have_content("Expires #{root_ca.not_after}")
        expect(page).to have_content("Issuer #{root_ca.issuer}")
        expect(page).to have_content("Subject #{root_ca.subject}")
      end
      context "remove the certificate" do
        before :each do
          click_link("Remove #{root_ca.serial} from MyCert1")
        end
        it "Asks for confirmation" do
          expect(page).to have_content("Remove this Certificate?")
        end
        context "confirm" do
          before :each do
            click_button("Remove")
          end
          it "shows an empty table" do
            expect(page).not_to have_css("tbody tr")
          end
          it "confirms the certificate has been removed" do
            expect(page).to have_content("Successfully removed Certificate: MyCert1")
          end
        end
      end
    end
  end

  describe "when uploading a certificate with a name already in use" do
    before do
      visit new_certificate_path
    end

    it "reports an error" do
      fill_in "Name", with: "MyCert1"
      attach_file("File", root_certificate_path)
      click_button "Upload Certificate"

      visit new_certificate_path
      fill_in "Name", with: "MyCert1"
      attach_file("File", intermediate_certificate_path)
      click_button "Upload Certificate"

      expect(page).to have_content "Certificate Name already taken"
    end
  end

  describe "when uploading the same certificate twice" do
    before do
      visit new_certificate_path
    end

    it "reports an error" do
      fill_in "Name", with: "MyCert1"
      attach_file("File", root_certificate_path)
      click_button "Upload Certificate"

      visit new_certificate_path
      fill_in "Name", with: "MyCert2"
      attach_file("File", root_certificate_path)
      click_button "Upload Certificate"

      expect(page).to have_content "This certificate has already been uploaded"
    end
  end
end
