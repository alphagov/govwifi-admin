require 'features/support/not_signed_in'
require 'features/support/sign_up_helpers'

describe 'View Health Checks' do
  context 'when logged out' do
    before do
      visit health_checks_path
    end

    it_behaves_like 'not signed in'
  end

  context 'when logged in' do
    let(:user) { create(:user, :confirmed, :with_organisation) }

    before do
      allow_any_instance_of(
        UseCases::Administrator::HealthChecks::CalculateHealth
      ).to receive(:execute).and_return(
        [ip_address: '111.111.111.111', status: :healthy]
      )

      sign_in_user user
      visit health_checks_path
    end

    it 'allows viewing the health checks' do
      expect(page).to have_content('Health Checks')
      expect(page).to have_content('111.111.111.111')
    end
  end
end
