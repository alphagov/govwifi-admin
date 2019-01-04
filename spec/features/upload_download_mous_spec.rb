describe 'the upload and download of MOUs' do
  context 'when logged out' do
    before { visit mou_index_path }

    it_behaves_like 'not signed in'
  end

  context 'As normal user' do
    let!(:organisation) { create(:organisation) }
    let!(:user) { create(:user, email: 'me@example.gov.uk', organisation: organisation) }

    before do
      sign_in_user user
    end

    context 'no file uploaded' do
      it 'should error' do
        visit mou_index_path
        click_on 'Upload'

        expect(page).to have_content("Choose a file before uploading")
      end
    end

    context 'uploading the signed mou' do
      it 'can upload and download a version of the mou' do
        visit mou_index_path

        attach_file("signed_mou", Rails.root + "spec/fixtures/mou.pdf")
        click_on 'Upload'

        expect(page).to have_content("MOU uploaded successfully.")
      end
    end

    context 'when trying to access MOU pages for admins' do
      it 'redirects unauthorised access' do
        visit admin_mou_index_path

        expect(page.current_path).to eq(setup_index_path)
      end
    end
  end

  context 'As a super admin' do
    let!(:organisation) { create(:organisation) }
    let!(:user) { create(:user, email: 'me@example.gov.uk', organisation: organisation, super_admin: true) }

    it 'uploads and downloads the mou template' do
      sign_in_user user
      visit admin_mou_index_path

      attach_file("unsigned_document", Rails.root + "spec/fixtures/mou.pdf")
      click_on 'Upload'

      expect(page).to have_content("MOU template uploaded successfully.")

      click_on 'Download current template'

      expect(page.body).to eq("12334567 signed mou with content\n")
    end
  end
end
