describe UseCases::Administrator::GenerateRadiusSecretKey do
  subject(:use_case) { described_class.new }

  it "has a length of 20 characters" do
    expect(use_case.execute.length).to eq(20)
  end
end
