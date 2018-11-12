describe 'sorting the columns in the organisation list' do
  context 'when admin views the names of organisations' do
    let!(:user) { create(:user, :confirmed, admin: true) }

    before do
      create(:organisation, name: "Department of Apple Cakes", created_at: Date.yesterday)
      create(:organisation, name: "Department of Silly Hats", created_at: 1.month.ago)
      create(:organisation, name: "Department of Xylophones", created_at: 2.years.from_now)

      sign_in_user user
      visit root_path
    end

    it 'can sort the organisations by names in descending order' do
      click_link 'Name'

      expect(page.body).to match(/Xylophones.*Silly Hats.*Apple Cakes/m)
    end

    context 'can toggle the order of the dates' do
      it 'can sort the dates from oldest to newest' do
        click_link 'Created on'

        expect(page.body).to match(/Silly Hats.*Apple Cakes.*Xylophones/m)
      end

      it 'can sort the dates from oldest to newest' do
        2.times { click_link 'Created on' }

        expect(page.body).to match(/Xylophones.*Apple Cakes.*Silly Hats/m)
      end
    end
  end
end
