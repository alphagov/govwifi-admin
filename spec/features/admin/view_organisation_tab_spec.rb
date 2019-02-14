describe 'the visibility of the organisation depending on user' do
  context 'when logged out' do
    before { visit admin_organisations_path }

    it_behaves_like 'not signed in'
  end

  context 'when logged in as Admin' do
    let(:organisation) { create(:organisation) }
    let(:user) { create(:user, email: 'me@example.gov.uk', organisation: organisation, super_admin: true) }

    it 'displays the organisation tab' do
      sign_in_user user
      visit root_path

      expect(page).to have_link(nil, href: admin_organisations_path)
    end
  end

  context 'when logged in as normal user' do
    let(:organisation) { create(:organisation) }
    let(:user) { create(:user, email: 'me@example.gov.uk', organisation: organisation) }

    it 'will not display the organisation tab' do
      sign_in_user user
      visit root_path

      expect(page).to_not have_link(nil, href: admin_organisations_path)
    end

    it 'will redirect to root if users type address manually' do
      sign_in_user user
      visit admin_organisations_path

      expect(page.current_path).to eq(setup_instructions_path)
    end
  end

  context 'comparing signed up organisations' do
    before do
      create(:organisation, name: "Gov Org 3", created_at: '10 Oct 2013')
      create(:organisation, name: "Gov Org 1", created_at: '10 Nov 2013')
      create(:organisation, name: "Gov Org 2", created_at: '10 Jan 2014')
    end

    let(:user) { create(:user, email: 'me@example.gov.uk', organisation: Organisation.first, super_admin: true) }

    it 'displays list of organisations in order of most recent' do
      sign_in_user user
      visit admin_organisations_path

      expect(page.body).to match(/Gov Org 2.*Gov Org 1.*Gov Org 3/m)
    end
  end
end
