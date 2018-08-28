require 'features/support/not_signed_in'
require 'features/support/sign_up_helpers'
require 'support/notifications_service'
require 'support/confirmation_use_case'

describe 'View Health Checks' do
  include_examples 'confirmation use case spy'
  include_examples 'notifications service'

  context 'when logged out' do
    before do
      visit health_checks_path
    end

    it_behaves_like 'not signed in'
  end

  context 'when logged in' do
    let(:user) { create(:user) }

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
