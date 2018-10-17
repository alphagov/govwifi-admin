describe 'specs should be run' do
  it 'should contain a directory with runnable specifications' do
    all_files = Dir['spec/**/*']
    non_spec_files = all_files.reject { |f| f.end_with?('_spec.rb') }
                       .select { |f| File.file?(f) }
                       .map { |f| File.open(f, 'r') }

    contains_describe = non_spec_files
                          .select { |f| f.read.include?('describe') }

    non_spec_files.map(&:close)

    error_message = 'one or more spec files are not being run! Make sure they end in _spec.rb!'

    expect(contains_describe.length).to eq(0), error_message
  end

  it 'should contain a directory with no focused tests' do
    if ENV['ATDD_DEVELOPMENT_MODE'] == 'true'
      skip 'we allow focused tests in ATDD mode'
    end

    focused_examples = RSpec.world
                          .all_examples
                          .select { |e| e.metadata[:focus] }

    focused_example_groups = RSpec.world
                                .all_example_groups
                                .select { |e| e.metadata[:focus] }

    expect(focused_examples.length).to eq(0)
    expect(focused_example_groups.length).to eq(0)
  end
end
