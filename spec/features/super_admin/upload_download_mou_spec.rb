describe 'Upload and download the MOU template', type: :feature do
  let(:super_admin) { create(:user, super_admin: true) }

  before do
    sign_in_user super_admin
    visit admin_mou_index_path
    attach_file('unsigned_document', Rails.root + 'spec/fixtures/mou.pdf')
  end

  context 'when uploading an MOU' do
    before do
      click_on 'Upload'
    end

    it 'uploads the mou template' do
      expect(page).to have_content('MOU template uploaded successfully.')
    end
  end

  context 'when dowloading the MOU template' do
    before do
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

    it 'redirects unauthorised access' do
      expect(page).to have_current_path(setup_instructions_path)
    end
  end
end
