describe 'Signing in as a super admin', type: :feature do
  let(:user) { create(:user, :super_admin) }
  let!(:organisation) { create(:organisation, name: "Gov Org 2") }

  context 'when visiting the home page' do
    before do
      sign_in_user user
      visit root_path
    end

    it 'shows list of signed organisations on the home page' do
      expect(page).to have_content("Gov Org 2")
    end

    it 'shows the super_org sidebar' do
      expect(page).to have_content 'Whitelist'
    end

    context 'when visiting a normal organisation' do
      before do
        user.organisations << organisation
      end

      it 'shows the normal organisation sidebar' do
        visit root_path

        click_on "Switch organisation"
        click_on "Gov Org 2"

        expect(page).not_to have_content 'Team Members'
      end
    end
  end
end
