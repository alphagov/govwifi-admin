describe AuthorisedEmailDomain do
  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }

    it 'validates the domain is in the correct shape' do
      invalid_examples = %i(
        justarandomstring
        i_contain_an_at_sign@gov.uk
        999999
      )

      invalid_examples.each do |invalid_example|
        expect(described_class.new(name: invalid_example).valid?).to eq(false)
      end

      valid_examples = %i(
        foo.com
        nhs.net
        123abc.foo.com
      )

      valid_examples.each do |valid_example|
        expect(described_class.new(name: valid_example).valid?).to eq(true)
      end
    end
  end
end
