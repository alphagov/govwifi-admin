shared_examples 'reset password use case spy' do
  require_relative './reset_password_use_case_spy'

  before do
    allow(UseCases::Administrator::SendResetPasswordEmail).to \
      receive(:new).and_return(ResetPasswordUseCaseSpy.new)
  end

  after do
    ResetPasswordUseCaseSpy.clear!
  end
end
