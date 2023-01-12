describe UseCases::OrganisationUsage do
  before do
    @metric = "time_to_first_ip",
              @median = 0,
              @date = Time.zone.today
    described_class.fetch_stats
  end

  it "gets displays the correct data" do
    expect(described_class.fetch_stats).to eq(
      {
        metric: "time_to_first_ip",
        median: @median,
        date: @date,
      },
    )
  end
end
