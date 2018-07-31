require_relative '../rails_helper'

describe MonitoringController, type: :controller do
  it "Should return a 200 to a healthchecker request" do
    get :healthcheck
    assert_response :success
  end
end
