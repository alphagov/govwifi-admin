describe 'healthcheck', type: :request do
  before { get '/healthcheck' }

  it 'responds successfully' do
    expect(response).to be_successful
  end
end
