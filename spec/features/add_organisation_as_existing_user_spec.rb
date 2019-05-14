describe 'Adding an organisation as exisiting user', type: :feature, focus: true do
  let(:organisation_1) { create(:organisation) }
  let(:user) { create(:user, organisations: [organisation_1]) }

  before do
    sign_in_user user
    visit change_organisation_path
  end

  it 'shows the create organisation button on the switch organisation page' do
    expect(page).to have_button('Add new organisation')
  end

  it 'displays the new organisation form' do
    click_on 'Add new organisation'
    expect(page).to have_content("Create your GovWifi network admin account")
  end

  context 'when submitting the form with correct info' do
    let(:organisation_2_name) { "Gov Org 3" }

    before do
      click_on 'Add new organisation'
      select organisation_2_name, from: 'name'
      fill_in 'Service email', with: "info@gov.uk"
    end

    it 'creates the organisation' do
      expect do
        click_on 'Create organisation'
      end.to change(Organisation, :count).by(1)
    end

    it 'associates the organisation to the user' do
      click_on 'Create organisation'
      expect(user.reload.organisations.map(&:name)).to eq([organisation_1.name, organisation_2_name])
    end
  end
end
