describe 'prompt organisation to sign an MOU' do
  let(:user) { create(:user, :confirmed, :with_organisation) }

  context 'when I have not uploaded an MOU' do
    context 'and I sign in' do
      before do
        sign_in_user user
        visit root_path
      end

      it 'prompts me' do
        expect(page).to have_content(
          "sign GovWifi's Memorandum of Understanding"
        )
      end

      context 'clicking the prompt' do
        before { click_on "sign GovWifi's Memorandum of Understanding" }

        it 'navigates me to managing MOUs' do
          expect(page).to have_content 'Download MOU'
          expect(page).to have_content 'Upload a copy of the signed MOU'
        end
      end
    end
  end
end
