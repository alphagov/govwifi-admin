require 'features/support/not_signed_in'
require 'features/support/sign_up_helpers'

describe 'the upload and download of MOUs', focus: true do
  before do
    Mou.create!
  end
  context 'when logged out' do
    before { visit mou_index_path }

    it_behaves_like 'not signed in'
  end

  context 'As normal user' do
    context 'uploading the signed mou' do
      let!(:organisation) { create(:organisation) }
      let!(:user) { create(:user, :confirmed, email: 'me@example.gov.uk', organisation: organisation) }

      it 'can upload and download a version of the mou' do
        sign_in_user user
        visit mou_index_path

        attach_file("signed_mou", Rails.root + "spec/fixtures/mou.pdf")
        click_on 'Upload'

        click_on 'Download your signed MOU'

        expect(page.body).to eq("12334567 signed mou with content\n")
      end
    end
  end

  context 'As a super admin' do
    let!(:organisation) { create(:organisation) }
    let!(:user) { create(:user, :confirmed, email: 'me@example.gov.uk', organisation: organisation, admin: true) }

    it ' uploads and downloads the mou template' do
      sign_in_user user
      visit admin_mou_index_path

      attach_file("unsigned_template", Rails.root + "spec/fixtures/mou.pdf")
      click_on 'Upload'

      click_on 'Download current template'

      expect(page.body).to eq("12334567 signed mou with content\n")
    end

    it 'uploads signed mou for an organisation' do
      sign_in_user user
      visit organisations_path

      attach_file("signed_mou", Rails.root + "spec/fixtures/mou.pdf")
      click_on 'Upload'

      click_on 'Download'

      expect(page.body).to eq("12334567 signed mou with content\n")
    end
  end
end
