describe LogsSearch do
  subject(:log_search) { described_class.new(filter: filter, search_term: search_term) }

  let(:search_term) { "" }
  let(:filter) { "" }

  context "when searching by username" do
    let(:filter) { "username" }

    context "with blank term" do
      it { is_expected.not_to be_valid }

      it "explains it is blank" do
        log_search.valid?
        expect(log_search.errors.first.message).to eq "Search term cannot be empty"
      end
    end

    context "with 4 characters" do
      let(:search_term) { "abcd" }

      it { is_expected.not_to be_valid }

      it "explains the required length" do
        log_search.valid?
        expect(log_search.errors.full_messages.first).to eq "Search term must be 5 or 6 characters"
      end
    end

    context "with 5 characters" do
      let(:search_term) { "abcde" }

      it { is_expected.to be_valid }
    end

    context "with 6 characters" do
      let(:search_term) { "abcdef" }

      it { is_expected.to be_valid }
    end

    context "with 7 characters" do
      let(:search_term) { "abcdefg" }

      it { is_expected.not_to be_valid }

      it "explains the required length" do
        log_search.valid?
        expect(log_search.errors.full_messages.first).to eq "Search term must be 5 or 6 characters"
      end
    end
  end

  context "when searching by IP" do
    let(:filter) { "ip" }

    context "with blank term" do
      it { is_expected.not_to be_valid }

      it "explains it is blank" do
        log_search.valid?
        expect(log_search.errors.first.message).to eq "Search term can't be blank'"
      end
    end

    context "with a search term containing only letters" do
      let(:search_term) { "badger" }

      it { is_expected.not_to be_valid }

      it "explains it is invalid" do
        log_search.valid?
        expect(log_search.errors.first.message).to eq "Search term must be a valid IP address"
      end
    end

    context "with a search term containing a mix of letters and numbers" do
      let(:search_term) { "10.x.20.30" }

      it { is_expected.not_to be_valid }

      it "explains it is invalid" do
        log_search.valid?
        expect(log_search.errors.first.message).to eq "Search term must be a valid IP address"
      end
    end

    context "with a search term that is a valid IPv4 address" do
      let(:search_term) { "11.22.33.44" }

      it { is_expected.to be_valid }
    end
  end
end
