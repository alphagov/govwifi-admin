require "spec_helper"

RSpec.describe "A very large request", type: :request do
  before do
    https!
  end

  it "should not overflow cookies" do
    get "/", params: { foo: "x" * ActionDispatch::Cookies::MAX_COOKIE_SIZE }
    expect(response).to redirect_to "/users/sign_in"
  end
end
