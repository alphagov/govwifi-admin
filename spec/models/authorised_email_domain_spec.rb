describe AuthorisedEmailDomain do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }

  context "when validating the email domain" do
    let(:invalid_examples) { %i[justarandomstring i_contain_an_at_sign@gov.uk 999999] }
    let(:valid_examples) { %i[foo.com nhs.net 123abc.foo.com] }

    it "is not valid when format is incorrect" do
      invalid_examples.each do |invalid_example|
        expect(described_class.new(name: invalid_example).valid?).to eq(false)
      end
    end

    it "is valid when format is correct" do
      valid_examples.each do |valid_example|
        expect(described_class.new(name: valid_example).valid?).to eq(true)
      end
    end
  end
end
