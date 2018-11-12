require 'features/support/sign_up_helpers'

describe 'sorting the columns in the organisation list' do
  context 'when admin views the table with organisation data' do
    let(:user) { create(:user, :confirmed, admin: true) }

    before do
      create(:organisation, name: "Department of Apple Cakes", created_at: Date.yesterday)
      create(:organisation, name: "Department of Silly Hats", created_at: 1.month.ago)
      create(:organisation, name: "Department of Xylophones", created_at: 2.years.from_now)

      sign_in_user user
      visit root_path
    end

    context 'and wants to sort by organisation name' do
      it 'by default, sorts the names in alphabetical order' do
        expect(page.body).to match(/Apple Cakes.*Silly Hats.*Xylophones/m)
      end

      it 'sorts the names in descending alphabetical order when Name is clicked once' do
        click_link 'Name'

        expect(page.body).to match(/Xylophones.*Silly Hats.*Apple Cakes/m)
      end
    end

    context 'and wants to sort by account creation date' do
      it 'sorts the organistions from oldest to newest when Created on is clicked once' do
        click_link 'Created on'

        expect(page.body).to match(/Silly Hats.*Apple Cakes.*Xylophones/m)
      end

      it 'sorts the organistions from newest to oldest when Created on is clicked twice' do
        2.times { click_link 'Created on' }

        expect(page.body).to match(/Xylophones.*Apple Cakes.*Silly Hats/m)
      end
    end
  end
end
