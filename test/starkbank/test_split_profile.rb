# frozen_string_literal: false

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')

describe(StarkBank::SplitProfile, '#split-profile#') do
  it 'put' do
    profiles = StarkBank::SplitProfile.put([ExampleGenerator.split_profile_example])
    profiles.each do |profile|
      expect(profile.id).wont_be_nil
    end
  end

  it 'query, page and get' do
    profiles = StarkBank::SplitProfile.query(limit: 3)
    profiles.each do |profile|
      expect(profile.id).wont_be_nil
    end

    ids = []
    cursor = nil
    (0..1).step(1) do
      page_profiles, cursor = StarkBank::SplitProfile.page(limit: 5, cursor: cursor)

      page_profiles.each do |profile|
        expect(ids).wont_include(profile.id)
        ids << profile.id
      end
      break if cursor.nil?
    end

    profile = StarkBank::SplitProfile.query(limit: 1).to_a[0]
    get_profile = StarkBank::SplitProfile.get(profile.id)
    expect(get_profile.id).must_equal(profile.id)
  end
end
