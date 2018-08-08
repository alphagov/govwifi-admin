require_relative '../rails_helper'

describe 'healthcheck', type: :request do
  it 'responds successfully' do
    get '/healthcheck'
    expect(response).to be_success
  end
end
