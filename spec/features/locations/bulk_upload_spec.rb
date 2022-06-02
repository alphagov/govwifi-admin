describe "Bulk upload locations and IPs", type: :feature do
  let(:user) { create(:user, :with_organisation) }
  let(:organisation) { user.organisations.first }

  before do
    sign_in_user user
    visit ips_path
    click_on "Upload Locations"
  end

  context "when uploading a locations CSV file" do
    it "displays the bulk upload page" do
      expect(page).to have_content("Upload a CSV file containing locations and Ips")
    end

    it "displays a link to the support page" do
      expect(page).to have_link("Contact GovWifi support", href: "/help")
    end

    context "when no file is chosen to upload" do
      before do
        click_on "Upload"
      end

      it "tells the user to choose a file" do
        expect(page).to have_content("Choose a file before uploading")
      end
    end

    context "when a PDF file is uploaded" do
      before do
        attach_file("File to Upload", Rails.root.join("spec/fixtures/mou.pdf"))
        click_on "Upload"
      end

      it "displays the appropriate error" do
        expect(page).to have_content("Invalid file type").twice
      end
    end

    context "when a CSV with commas as delimiter is uploaded" do
      before do
        attach_file("File to Upload", Rails.root.join("spec/fixtures/csv/locations_upload_no_dupes_commas.csv"))
        click_on "Upload"
      end

      it "displays the appropriate error" do
        expect(page).to have_content("Invalid data structure").twice
      end
    end

    context "when a CSV with locations but no IPs is uploaded the summary page" do
      before do
        attach_file("File to Upload", Rails.root.join("spec/fixtures/csv/locations_upload_no_ips.csv"))
        click_on "Upload"
      end

      it "displays the uploaded locations" do
        expect(page).to have_content("Some Address")
        expect(page).to have_content("AL2 2LU")
        expect(page).to have_content("Another Address")
        expect(page).to have_content("E1 2QE")
      end

      it "has a save button" do
        expect(page).to have_button("Save")
      end
    end

    context "when a CSV with locations and IPs is uploaded the summary page" do
      before do
        attach_file("File to Upload", Rails.root.join("spec/fixtures/csv/locations_upload_no_dupes.csv"))
        click_on "Upload"
      end

      it "displays the uploaded locations" do
        expect(page).to have_content("Some Address")
        expect(page).to have_content("AL2 2LU")
        expect(page).to have_content("Another Address")
        expect(page).to have_content("E1 2QE")
      end

      it "displays the uploaded IP addresses" do
        expect(page).to have_content("81.1.1.1")
        expect(page).to have_content("81.2.2.2")
        expect(page).to have_content("82.1.1.1")
        expect(page).to have_content("82.2.2.2")
      end

      it "has a save button" do
        expect(page).to have_button("Save")
      end
    end

    context "when a CSV with an invalid postcode is uploaded the summary page" do
      before do
        attach_file("File to Upload", Rails.root.join("spec/fixtures/csv/locations_upload_no_dupes_invalid_postcode.csv"))
        click_on "Upload"
      end

      it "displays the invalid postcode error message" do
        expect(page).to have_content("Postcode must be valid").twice
      end

      it "does not have a save button" do
        expect(page).not_to have_button("Save")
      end
    end

    context "when a CSV with existing locations is uploaded the summary page" do
      before do
        l = FactoryBot.create(:location, address: "Some Address", postcode: "AL2 2LU", organisation:)
        FactoryBot.create(:location, address: "Another Address", postcode: "E1 2QE", organisation:)
        FactoryBot.create(:ip, address: "81.1.1.1", location: l)
        FactoryBot.create(:ip, address: "81.2.2.2", location: l)
        FactoryBot.create(:ip, address: "82.1.1.1", location: l)
        FactoryBot.create(:ip, address: "82.2.2.2", location: l)
        attach_file("File to Upload", Rails.root.join("spec/fixtures/csv/locations_upload_no_dupes.csv"))
        click_on "Upload"
      end

      it "displays the location address error messages" do
        expect(page).to have_content("Location address already exists for this organisation", count: 4)
      end

      it "displays the IP address error messages" do
        expect(page).to have_content("IP address is already in use", count: 8)
      end

      it "does not have a save button" do
        expect(page).not_to have_button("Save")
      end
    end

    context "when a CSV with duplicate locations is uploaded the summary page" do
      before do
        attach_file("File to Upload", Rails.root.join("spec/fixtures/csv/locations_upload_with_dupes.csv"))
        click_on "Upload"
      end

      it "displays the location address error messages" do
        expect(page).to have_content("Location address included multiple times in upload", count: 4)
      end

      it "displays the IP address error messages" do
        expect(page).to have_content("IP address included multiple times in upload", count: 4)
      end

      it "does not have a save button" do
        expect(page).not_to have_button("Save")
      end
    end
  end
end
