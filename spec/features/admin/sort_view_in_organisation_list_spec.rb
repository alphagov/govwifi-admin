describe 'sorting the columns in the organisation list' do
  context 'when admin views the names of organisations' do
    let!(:user) { create(:user, :confirmed, admin: true) }

    before do
      create(:organisation, name: "ABC", created_at: Date.yesterday)
      create(:organisation, name: "DEF", created_at: 1.month.ago)
      create(:organisation, name: "XYZ", created_at: 2.years.from_now)

      sign_in_user user
      visit root_path
    end

    it 'can sort the organisations by names in descending order' do
      click_link 'Name'

      expect(page.body).to match(/XYZ.*DEF.*ABC/m)
    end

    context 'can toggle the order of the dates' do
      it 'can sort the dates from oldest to newest' do
        click_link 'Created on'

        expect(page.body).to match(/DEF.*ABC.*XYZ/m)
      end

      it 'can sort the dates from oldest to newest' do
        2.times { click_link 'Created on' }

        expect(page.body).to match(/XYZ.*ABC.*DEF/m)
      end
    end
  end
end
