describe "POST /locations" do
  let(:params) do
    {
      "utf8"=>"✓",
      "location" => {
        "address" => "6-8 HEMMING ST",
        "postcode" => "E1 5BL",
        "ips_attributes" =>
        {
            "0" => {"address" => "34.3.4.3"},
            "1" => {"address"=>"34.3.4.2"},
            "2" => {"address"=>""},
            "3" => {"address"=>""},
            "4" => {"address"=>""}
        }
      }, "commit"=>"Add new location"
    }
  end

  before do
    organisation = create(:organisation)
    user = create(:user, organisation: organisation)
    login_as(user, scope: :user)
  end

  it "does not add invalid IPs" do
    result = post locations_path, params: params
    expect(Ip.count).to be_zero
  end
end
