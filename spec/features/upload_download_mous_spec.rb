require 'features/support/not_signed_in'
require 'features/support/sign_up_helpers'

describe 'the upload and download of MOUs' do
  context 'when logged out' do
    before { visit organisations_mou_index_path }

    it_behaves_like 'not signed in'
  end

  context 'as a normal user' do
    let(:organisation) { create(:organisation) }
    let(:user) { create(:user, :confirmed, email: 'me@example.gov.uk', organisation: organisation) }

    before do
      sign_in_user user
    end

    context 'uploading an mou' do
      before do
        visit organisations_mou_index_path
        attach_file("signed_mou", Rails.root + "spec/fixtures/mou.pdf")
        click_on 'Upload'
      end

      it 'reports the upload worked' do
        expect(page).to have_content("MOU uploaded successfully.")
      end

      it 'allows downloading the mou again' do
        click_on 'Download your signed MOU'
        expect(page.body).to eq("12334567 signed mou with content\n")
      end

      context 'and then visiting the homepage' do
        before { visit root_path }

        it 'does not prompt me to upload the MOU' do
          expect(page).to_not have_content(
            "sign GovWifi's Memorandum of Understanding"
          )
        end
      end
    end

    context 'when trying to access MOU pages for admins' do
      it 'redirects unauthorised access' do
        visit admins_mou_index_path

        expect(page.current_path).to eq(root_path)
      end
    end
  end

  context 'as a super admin' do
    let!(:organisation) { create(:organisation) }
    let!(:user) { create(:user, :confirmed, email: 'me@example.gov.uk', organisation: organisation, admin: true) }

    it 'uploads and downloads the mou template' do
      sign_in_user user
      visit admins_mou_index_path

      attach_file("unsigned_document", Rails.root + "spec/fixtures/mou.pdf")
      click_on 'Upload'

      expect(page).to have_content("MOU template uploaded successfully.")

      click_on 'Download current template'

      expect(page.body).to eq("12334567 signed mou with content\n")
    end

    it 'uploads signed mou for an organisation' do
      sign_in_user user
      visit organisations_path

      attach_file("signed_mou", Rails.root + "spec/fixtures/mou.pdf")
      click_on 'Upload'

      expect(page).to have_content("MOU uploaded successfully.")

      click_on 'Download'

      expect(page.body).to eq("12334567 signed mou with content\n")
    end
  end
end
