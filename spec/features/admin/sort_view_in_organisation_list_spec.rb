require 'features/support/sign_up_helpers'

describe 'sorting the values in the organisation list' do
  context 'when super admin views the list' do
    let(:super_admin) { create(:user, :confirmed, admin: true) }

    before do
      create(:organisation, name: "Department of Silly Hats", created_at: '10 Dec 2013')
      create(:organisation, name: "Department of Apple Cakes", created_at: '10 Feb 2014')
      create(:organisation, name: "Department of Xylophones", created_at: '10 May 2016')

      sign_in_user super_admin
      visit root_path
    end

    context 'and sorts by organisation name' do
      it 'sorts the list from A -Z, by default' do
        expect(page.body).to match(/Apple Cakes.*Silly Hats.*Xylophones/m)
      end

      it 'sorts the list in reverse, when Name is clicked once' do
        click_link 'Name'

        expect(page.body).to match(/Xylophones.*Silly Hats.*Apple Cakes/m)
      end
    end

    context 'and sorts by account creation date' do
      it 'sorts the list from oldest to newest, when Created on is clicked once' do
        click_link 'Created on'

        expect(page.body).to match(/Silly Hats.*Apple Cakes.*Xylophones/m)
      end

      it 'sorts the list from newest to oldest, when Created on is clicked twice' do
        2.times { click_link 'Created on' }

        expect(page.body).to match(/Xylophones.*Apple Cakes.*Silly Hats/m)
      end
    end

    context 'and sorts by signed MoU uploads' do
      before do
        create(:organisation, name: "Has No MoU Company")

        create(:organisation, name: "Has Newer MoU Company").signed_mou.attach(
          io: File.open(Rails.root + "spec/fixtures/mou.pdf"), filename: "mou.pdf"
        )

        create(:organisation, name: "Has Older MoU Company").signed_mou.attach(
          io: File.open(Rails.root + "spec/fixtures/mou.pdf"), filename: "mou.pdf"
        )

        Organisation.find_by(name: "Has Newer MoU Company").signed_mou_attachment.update(created_at: 3.months.from_now)
      end

      it 'sorts the list by oldest to most recent, when MoU signed is clicked once' do
        click_link 'MoU Signed'

        expect(page.body).to match(/No MoU.*Older MoU.*Newer MoU/m)
      end

      it 'sorts the list by most recent to oldest, when MoU signed is clicked twice' do
        2.times { click_link 'MoU Signed' }

        expect(page.body).to match(/Newer MoU.*Older MoU.*No MoU/m)
      end
    end
  end
end
