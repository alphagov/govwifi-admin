describe 'A confirmed user with no organisation memberships logs in', type: :feature do
  let(:user) { create(:user, organisations: []) }

  context 'with an existing confirmed user' do
    before do
      sign_in_user user
      visit root_path
    end

    it 'redirects to the change organisation path' do
      expect(current_path).to eq(new_organisation_path)
    end

    it 'prints an instruction' do
      expect(page).to have_content("Please select your organisation")
    end

    context 'when the user opts to contact support' do
      before do
        visit technical_support_new_help_path
      end

      it 'presents the user with a support form' do
        expect(page).to have_content("Network administrator technical support")
      end
    end
  end
end
