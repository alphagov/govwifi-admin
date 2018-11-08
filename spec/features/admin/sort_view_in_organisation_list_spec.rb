describe 'sorting the columns in the organisation list', focus: true  do
  context 'when admin views the names of organisations' do
    let!(:organisation_1) { create(:organisation, name: "ABC", created_at: Date.yesterday) }
    let!(:organisation_2) { create(:organisation, name: "DEF", created_at: 1.month.ago) }
    let!(:organisation_3) { create(:organisation, name: "XYZ", created_at: 2.years.from_now) }

    let!(:user) { create(:user, :confirmed, admin: true) }

    it 'can sort the organisations by names in descending order' do
      sign_in_user user
      visit root_path

      click_link 'Name'

      expect(page.body).to match(/XYZ.*DEF.*ABC/m)
    end

    context 'and interested in the account creation date' do
      it 'can sort the dates from newest to oldest' do
        sign_in_user user
        visit root_path

        click_link 'Created At'

        expect(page.body).to match(/XYZ.*ABC.*DEF/m)
      end
    end
  end
end
