require "rspec/expectations"

RSpec::Matchers.define :download_file do |expected|
  match do |actual|
    unless actual.is_a? Capybara::Session
      raise "you must call this matcher on a Capybara session (page object)"
    end

    unless expected.is_a? ActiveStorage::Attached
      raise "you must call this matcher with an ActiveStorage attachment"
    end

    expected.blob.download == actual.body
  end
end
