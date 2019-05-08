describe 'Deleting an organisation', type: :feature, focus: true do
  let!(:admin_user) { create(:user, :super_admin) }
  let!(:organisation) { create(:organisation, name: 'Gov Org 2') }

  context 'when visiting the organisations page' do
    before do
      sign_in_user admin_user
      visit admin_organisation_path(organisation)
      click_on 'Delete organisation'
    end

    it 'shows the organisations page I am on' do
      expect(page).to have_content("Gov Org 2")
    end

    it 'shows a delete organisation button on the page' do
      expect(page).to have_content("Delete organisation")
    end

    it 'prompts with a flash message to delete the organisation' do
      expect(page).to have_content("Are you sure you want to delete")
    end

    it 'notifies the user when a organsiation has been deleted' do
      click_on 'Yes, remove this organisation'
      expect(page).to have_content("Organisation has been removed")
    end

    it 'removes the organisation from the index list of orgs' do
      click_on 'Yes, remove this organisation'
      expect(page).not_to have_content("Gov Org 2")
    end

    context 'when deleting an organisation' do
      let(:organisation_names_gateway) { instance_spy(Gateways::S3) }

      before do
        allow(Gateways::S3).to receive(:new).and_return(organisation_names_gateway)
      end

      it 'publishes the updated list of organisation names to S3' do
        click_on 'Yes, remove this organisation'
        expect(organisation_names_gateway).to have_received(:write).with(data: "- Gov Org 1")
      end
    end
  end
end
