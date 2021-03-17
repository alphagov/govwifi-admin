require "rails_helper"

RSpec.describe Users::InvitationsController, type: :controller do
  describe "POST /users/invitation" do
    context "when the user is not logged in" do
      it "redirects to root_path" do
        response = post :create

        expect(response).to redirect_to(root_path)
      end
    end
  end
end
