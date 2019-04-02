describe 'Upload and download the MOU template', type: :feature do
  let(:super_admin) { create(:user, super_admin: true) }

  before do
    sign_in_user super_admin
    visit admin_mou_index_path
  end

  context 'when uploading an MOU' do
    before do
      attach_file('unsigned_document', Rails.root + 'spec/fixtures/mou.pdf')
      click_on 'Upload'
    end

    it 'uploads the mou template' do
      expect(page).to have_content('MOU template uploaded successfully.')
    end
  end

  context 'when no file is uploaded' do
    before do
      click_on 'Upload'
    end

    it 'shows the user an error message' do
      expect(page).to have_content('No MoU template selected. Please select a file and try again')
    end
  end

  context 'when dowloading the MOU template' do
    before do
      attach_file('unsigned_document', Rails.root + 'spec/fixtures/mou.pdf')
      click_on 'Upload'
      click_on 'Download current template'
    end

    it 'downloads the MOU' do
      expect(page).to have_content('12334567 signed mou with content')
    end
  end

  context 'without super admin privileges' do
    before do
      sign_out
      sign_in_user create(:user)
      visit admin_mou_index_path
    end

    it_behaves_like 'shows the setup instructions page'
  end
end
