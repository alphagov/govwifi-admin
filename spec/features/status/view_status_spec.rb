describe 'View GovWifi status', type: :feature do
  context 'when logged out' do
    before do
      visit status_index_path
    end

    it_behaves_like 'not signed in'
  end

  context 'when logged in' do
    let(:user) { create(:user) }
    let(:use_case) { instance_double(UseCases::Administrator::HealthChecks::CalculateHealth) }

    before do
      allow(
        UseCases::Administrator::HealthChecks::CalculateHealth
      ).to receive(:new).and_return(use_case)

      allow(use_case).to receive(:execute).and_return(
        [ip_address: '111.111.111.111', status: :operational]
      )

      sign_in_user user
      visit status_index_path
    end

    it 'allows viewing the GovWifi Status' do
      expect(page).to have_content('Status')
    end

    it 'displays the IP' do
      expect(page).to have_content('111.111.111.111')
    end
  end
end
