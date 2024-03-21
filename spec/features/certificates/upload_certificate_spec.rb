describe "Upload Certificate", type: :feature do
  let(:organisation) { create(:organisation, :with_cba_enabled) }
  let(:user) { create(:user, organisations: [organisation]) }

  before do
    sign_in_user user
  end

  context "when organisation is enabled for cba" do
    before do
      visit root_path
    end

    it "displays the Certificates link on the left nav" do
      @section = page.find(".leftnav")
      expect(@section).to have_content("Certificates")
    end

    it "takes you to the form to upload a certificate" do
      click_on "Certificates"
      expect(page).to have_link("Add Certificate")

      click_on "Add Certificate"
      expect(page).to have_content "Add Certificate"
    end
  end

  context "when uploading a certificate without choosing a file" do
    before do
      visit new_certificate_path
    end

    it "reports an error" do
      fill_in "Name", with: "MyCert1"
      click_button "Upload Certificate"

      expect(page).to have_content "No Certificate file selected. Please choose a file to try again."
    end
  end

  context "when uploading a certificate without setting a name" do
    before do
      visit new_certificate_path
    end

    it "reports an error" do
      attach_file("Cert", Rails.root.join("spec/models/root_ca.pem"))
      click_button "Upload Certificate"

      expect(page).to have_content "Certificate Name can't be blank"
    end
  end

  context "when uploading a malformed certificate" do
    before do
      visit new_certificate_path
    end

    it "reports an error" do
      attach_file("Cert", Rails.root.join("spec/models/bad_cert.pem"))
      click_button "Upload Certificate"

      expect(page).to have_content "Certificate file issue: PEM_read_bio_X509: bad base64 decode"
    end
  end

  context "when uploading a valid certificate" do
    before do
      visit new_certificate_path
    end

    it "reports an error" do
      fill_in "Name", with: "MyCert1"
      attach_file("Cert", Rails.root.join("spec/models/root_ca.pem"))
      click_button "Upload Certificate"

      expect(page).to have_current_path(certificates_path)
    end
  end

  context "when uploading a certificate with a name already in use" do
    before do
      visit new_certificate_path
    end

    it "reports an error" do
      fill_in "Name", with: "MyCert1"
      attach_file("Cert", Rails.root.join("spec/models/root_ca.pem"))
      click_button "Upload Certificate"

      visit new_certificate_path
      fill_in "Name", with: "MyCert1"
      attach_file("Cert", Rails.root.join("spec/models/intermediate_ca.pem"))
      click_button "Upload Certificate"

      expect(page).to have_content "Certificate Name already taken"
    end
  end

  context "when uploading the same certificate twice" do
    before do
      visit new_certificate_path
    end

    it "reports an error" do
      fill_in "Name", with: "MyCert1"
      attach_file("Cert", Rails.root.join("spec/models/root_ca.pem"))
      click_button "Upload Certificate"

      visit new_certificate_path
      fill_in "Name", with: "MyCert2"
      attach_file("Cert", Rails.root.join("spec/models/root_ca.pem"))
      click_button "Upload Certificate"

      expect(page).to have_content "Identical Certificate already exists"
    end
  end
end
