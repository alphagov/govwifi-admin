describe 'sorting the columns in the organisation list', focus: true  do
  context 'when admin views the names of organisations' do
    let!(:organisation_1) { create(:organisation, name: "ABC") }
    let!(:organisation_2) { create(:organisation, name: "DEF") }
    let!(:organisation_3) { create(:organisation, name: "XYZ") }

    let!(:user) { create(:user, :confirmed, admin: true) }

    it 'can sort the names in descending order' do
      sign_in_user user
      visit root_path

      click_link 'Name'

      expect(page.body).to match(/XYZ.*DEF.*ABC/m)
    end
  end
end
