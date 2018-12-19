describe 'healthcheck' do
  it 'responds successfully' do
    get '/healthcheck'
    expect(response).to be_successful
  end
end
