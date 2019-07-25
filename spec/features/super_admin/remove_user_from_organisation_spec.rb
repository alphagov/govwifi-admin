describe "Removing a team member from an organisation as a super admin", type: :feature do
  let(:organisation) { create(:organisation, name: "Gov Org 3") }
  let(:super_admin) { create(:user, :super_admin) }
  let(:user) { create(:user, organisations: [organisation]) }

  before do
    user
    sign_in_user super_admin
    visit super_admin_organisation_path(organisation)
    click_on 'Remove user'
  end

  it 'requires confirmation of user removal' do
    expect(page).to have_button('Yes, remove this team member')
  end

  context 'when confirming user removal' do
    before { click_on 'Yes, remove this team member' }

    it 'redirects back to the original organisation' do
      expect(page).to have_current_path(super_admin_organisation_path(organisation))
    end

    it 'notifies that a team member has been removed' do
      expect(page).to have_content('Team member has been removed')
    end
  end
end
