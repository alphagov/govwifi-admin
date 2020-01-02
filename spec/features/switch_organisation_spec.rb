require 'rack_session_access/capybara'

describe 'Multiple organisations', type: :feature do
  let(:organisation_1) { create(:organisation) }
  let(:organisation_2) { create(:organisation) }
  let(:user) { create(:user) }

  before do
    user.organisations << organisation_1
    sign_in_user user
  end

  context "when switching organisations" do
    before do
      user.organisations << organisation_2
      visit root_path
      click_on 'Switch organisation'
    end

    it 'does not display the sidenav' do
      expect(page).not_to have_selector '.leftnav'
    end

    it 'displays a button for organisation one' do
      expect(page).to have_button(organisation_1.name)
    end

    it 'displays a button for organisation two' do
      expect(page).to have_button(organisation_2.name)
    end

    it 'changes the organisation the user is viewing' do
      click_on organisation_2.name
      within ".subnav" do
        expect(page).to have_content(organisation_2.name)
      end
    end
  end

  context "when the session is updated manually" do
    context "when the user doesn't belong to the organisation in the session" do
      before do
        page.set_rack_session(organisation_id: organisation_2.id)
        visit root_path
      end

      it 'dissallows switching to that organisation' do
        expect(page).not_to have_content(organisation_2.name)
      end
    end

    context "when the user belongs to the organisation in the session" do
      before do
        user.organisations << organisation_2
        page.set_rack_session(organisation_id: organisation_2.id)
        visit root_path
      end

      it 'allows switching to that organisation' do
        expect(page).to have_content(organisation_2.name)
      end
    end
  end
end
