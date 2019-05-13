describe 'Uploading and downloading an MOU', type: :feature do
  let(:user) { create(:user, :with_organisation) }

  context "when signed in" do
    before do
      sign_in_user user
    end

    context 'when no file is chosen to upload' do
      before do
        visit mou_index_path
        click_on 'Upload'
      end

      it 'displays an error to the user' do
        expect(page).to have_content("Choose a file before uploading")
      end
    end

    context 'when uploading the signed mou' do
      before do
        visit mou_index_path
        attach_file("signed_mou", Rails.root + "spec/fixtures/mou.pdf")
        click_on 'Upload'
      end

      it 'can upload a version of the mou' do
        expect(page).to have_content("MOU uploaded successfully.")
      end

      it 'displays the download link' do
        expect(page).to have_link("download and view the document.")
      end

      it 'redirects to "after MOU uploaded" path for analytics' do
        expect(page).to have_current_path('/mou/created')
      end
    end

    context 'when replacing the signed mou' do
      before do
        visit mou_index_path
        attach_file("signed_mou", Rails.root + "spec/fixtures/mou.pdf")
        click_on 'Upload'
        attach_file("signed_mou", Rails.root + "spec/fixtures/mou.pdf")
        click_on 'Replace MOU'
      end

      it 'can upload a version of the mou' do
        expect(page).to have_content("MOU uploaded successfully.")
      end

      it 'displays the download link' do
        expect(page).to have_link("download and view the document.")
      end

      it 'redirects to "after MOU uploaded" path for analytics' do
        expect(page).to have_current_path('/mou/replaced')
      end
    end
  end

  context 'when signed out' do
    before do
      visit mou_index_path
    end

    it_behaves_like 'not signed in'
  end
end
