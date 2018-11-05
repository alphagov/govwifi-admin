shared_examples 'unlock account use case spy' do
  require_relative './unlock_account_use_case_spy'

  before do
    allow(UseCases::Administrator::UnlockAccountEmail).to \
      receive(:new).and_return(UnlockAccountUseCaseSpy.new)
  end

  after do
    UnlockAccountUseCaseSpy.clear!
  end
end
