describe "DELETE /users/:id", type: :request do
  let(:user) { create(:user, :with_organisation) }
  let(:super_admin) { create(:user, :with_organisation, :super_admin) }

  before do
    https!
    sign_in_user(super_admin, pass_through_two_factor: true )
  end

  it "deletes the user" do
    expect {
      delete user_registration_path(user, format: :html)
    }.to change(User, :count).by(-1)
  end

end
