describe UseCases::Administrator::GenerateRadiusSecretKey do
  it 'has a length of 20 characters' do
    expect(subject.execute.length).to eq(20)
  end
end
