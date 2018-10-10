describe 'when a user signs in it asks the users to go and sign their MoU' do
  include_examples 'confirmation use case spy'
  include_examples 'notifications service'

  let!(:user) { create(:user, :confirmed, :with_organisation) }

  before do
    sign_in_user user
    visit root_path
  end

  context 'user doesnt have a signed MoU' do
    it 'shows the user a prompt to sign their MoU form' do
      expect(page).to have_content("Please sign your MoU*")
    end

    context 'user has signed their MoU form' do
      it 'does not show a prompt' do
        expect(page).to have_content("Get GovWifi Access in your Organisation")
      end
    end
  end
end
