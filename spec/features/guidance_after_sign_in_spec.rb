require 'features/support/sign_up_helpers'
require 'support/notifications_service'

describe 'guidance after sign in' do
  let(:user) { create(:user, :confirmed, :with_organisation) }

  before do
    sign_in_user user
    visit '/'
  end

  it 'shows me the landing guidance' do
    expect(page).to have_content 'Get GovWifi'
    expect(page).to have_content 'Getting help'
  end
end
