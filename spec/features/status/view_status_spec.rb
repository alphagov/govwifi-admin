require 'features/support/not_signed_in'
require 'features/support/sign_up_helpers'

describe 'View GovWifi Status' do
  context 'when logged out' do
    before do
      visit status_index_path
    end

    it_behaves_like 'not signed in'
  end

  context 'when logged in' do
    let(:user) { create(:user, :confirmed) }

    before do
      allow_any_instance_of(
        UseCases::Administrator::HealthChecks::CalculateHealth
      ).to receive(:execute).and_return(
        [ip_address: '111.111.111.111', status: :operational]
      )

      sign_in_user user
      visit status_index_path
    end

    it 'allows viewing the GovWifi Status' do
      expect(page).to have_content('Status')
      expect(page).to have_content('111.111.111.111')
    end
  end
end
