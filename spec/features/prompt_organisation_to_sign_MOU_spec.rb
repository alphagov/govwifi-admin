describe 'prompt organisation to sign an MOU' do
  let(:user) { create(:user, :confirmed, :with_organisation) }

  context 'when visiting the home page' do
    before do
      sign_in_user user
      visit root_path
    end

    # organisation#mou_signed is stubbed as true, so this
    # is always the behaviour
    context 'and my organisation has signed an MOU' do
      it 'does not prompt me' do
        expect(page).to_not have_content(
          "sign GovWifi's Memorandum of Understanding"
        )
      end
    end

    # To be implemented once organisation#mou_signed isn't faked
    # context 'and my organisation has not signed an MOU' do
    #   before do
    #     organisation.delete_mou! # fix this signature
    #   end

    #   it 'prompts me' do
    #     expect(page).to have_content(
    #       "sign GovWifi's Memorandum of Understanding"
    #     )
    #   end
    # end
  end
end
