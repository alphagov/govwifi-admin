describe 'prompt organisation to sign an MOU' do
  let(:user) { create(:user, :confirmed, :with_organisation) }

  context 'when I have uploaded an MOU' do
    before do
      # user.MOU = something
    end

    context 'and I sign in' do
      before do
        sign_in_user user
        visit root_path
      end

      it 'does not prompt me' do
        expect(page).to_not have_content(
          "sign GovWifi's Memorandum of Understanding"
        )
      end
    end
  end

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
    end
  end
end
