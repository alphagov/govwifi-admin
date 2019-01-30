describe 'sorting the values in the organisation list' do
  context 'when super admin views the list' do
    let!(:super_admin) { create(:user, super_admin: true) }

    before do
      create(:organisation, name: "Org 2", created_at: '10 Dec 2013')
      create(:organisation, name: "Org 3", created_at: '10 Feb 2014')

      sign_in_user super_admin
      visit root_path
    end

    context 'and sorts by account creation date' do
      it 'sorts the list from newest to oldest, by default' do
        expect(page.body).to match(/Org 1.*Org 3.*Org 2/m)
      end

      it 'sorts the list from oldest to newest, when Created on is clicked once' do
        click_link 'Created on'

        expect(page.body).to match(/Org 2.*Org 3.*Org 1/m)
      end
    end

    context 'and sorts by organisation name' do
      it 'sorts the list from A -Z, when Name is clicked once' do
        click_link 'Name'

        expect(page.body).to match(/Org 1.*Org 2.*Org 3/m)
      end

      it 'sorts the list in reverse alphabetical order, when Name is clicked twice' do
        2.times { click_link 'Name' }

        expect(page.body).to match(/Org 3.*Org 2.*Org 1/m)
      end
    end

    context 'and sorts by signed MoU uploads' do
      before do
        create(:organisation, name: "Org 4")

        Organisation.find_by(name: "Org 1").signed_mou.attach(
          io: File.open(Rails.root + "spec/fixtures/mou.pdf"), filename: "mou.pdf"
        )

        Organisation.find_by(name: "Org 3").signed_mou.attach(
          io: File.open(Rails.root + "spec/fixtures/mou.pdf"), filename: "mou.pdf"
        )

        Organisation.find_by(name: "Org 3").signed_mou_attachment.update(created_at: 3.months.from_now)
      end

      it 'sorts the list by oldest to most recent, when MoU signed is clicked once' do
        click_link 'MoU Signed'

        expect(page.body).to match(/Org 4.*Org 1.*Org 3/m)
      end

      it 'sorts the list by most recent to oldest, when MoU signed is clicked twice' do
        2.times { click_link 'MoU Signed' }

        expect(page.body).to match(/Org 3.*Org 1.*Org 4/m)
      end
    end
  end
end
