describe "GET ERRORS", type: :request do
  let(:user) { create(:user) }

  before do
    https!
    login_as(user, scope: :user)
  end

  it "show 500 error page" do
    get "/this_path_wont_work"
    binding.pry
  end
end
