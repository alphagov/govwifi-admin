shared_context 'when sending a cross organisation invite email' do
  require_relative './cross_organisation_invite_use_case_spy'

  before do
    allow(UseCases::Administrator::SendCrossOrganisationInviteEmail).to \
      receive(:new).and_return(CrossOrganisationInviteUseCaseSpy.new)
  end

  after do
    CrossOrganisationInviteUseCaseSpy.clear!
  end
end
