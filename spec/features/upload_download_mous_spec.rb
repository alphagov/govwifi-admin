describe "Uploading and downloading an MOU", type: :feature do
  let(:user) { create(:user, :with_organisation) }
  let(:superadmin) { create(:user, :super_admin) }

  context "when signed in" do
    before do
      sign_in_user user
    end

    describe "MOU template" do
      before do
        visit root_path
        sign_out

        sign_in_user superadmin
        visit super_admin_mou_index_path
        attach_file("unsigned_document", Rails.root + "spec/fixtures/mou.pdf")
        click_on "Upload"
        sign_out

        sign_in_user user
        visit mou_index_path
      end

      it "allows users to download the MOU template" do
        click_on "Download a copy of the MOU"

        expect(page.current_path).to start_with "/rails/active_storage/disk/"
      end
    end

    context "when no file is chosen to upload" do
      before do
        visit mou_index_path
        click_on "Upload"
      end

      it "displays an error to the user" do
        expect(page).to have_content("Choose a file before uploading")
      end
    end

    context "when uploading the signed mou" do
      before do
        visit mou_index_path
        attach_file("signed_mou", Rails.root + "spec/fixtures/mou.pdf")
        click_on "Upload"
      end

      it "can upload a version of the mou" do
        expect(page).to have_content("MOU uploaded successfully.")
      end

      it "displays the download link" do
        expect(page).to have_link("download and view the document.")
      end

      it 'redirects to "after MOU uploaded" path for analytics' do
        expect(page).to have_current_path("/mou/created")
      end

      describe "access control" do
        before do
          visit mou_index_path
          @link = page.find("a", text: "download and view the document.")[:href]
        end

        context "when someone is not authenticated" do
          before do
            sign_out
          end

          it "asks the user to authenticate" do
            visit @link

            expect(page).to have_current_path(new_user_session_path)
          end
        end

        context "when someone is not part of the mou's organisations" do
          before do
            sign_in_user create(:user, :with_organisation)
          end

          it "redirects the user to the overview with a message" do
            visit @link

            expect(page).to have_current_path(overview_index_path)
            expect(page).to have_content("You are not allowed to see this MoU.")
          end
        end

        context "when someone is a rightful member of the organisation" do
          it "lets them download the MoU" do
            visit @link

            # as we're running locally, the actual asset lives under rails/active_storage/disk
            expect(page.current_path).to start_with("/rails/active_storage/disk")
          end
        end
      end
    end

    context "when replacing the signed mou" do
      before do
        visit mou_index_path
        attach_file("signed_mou", Rails.root + "spec/fixtures/mou.pdf")
        click_on "Upload"
        attach_file("signed_mou", Rails.root + "spec/fixtures/mou.pdf")
        click_on "Replace MOU"
      end

      it "can upload a version of the mou" do
        expect(page).to have_content("MOU uploaded successfully.")
      end

      it "displays the download link" do
        expect(page).to have_link("download and view the document.")
      end

      it 'redirects to "after MOU uploaded" path for analytics' do
        expect(page).to have_current_path("/mou/replaced")
      end
    end
  end

  context "when signed out" do
    before do
      visit mou_index_path
    end

    it_behaves_like "not signed in"
  end
end
