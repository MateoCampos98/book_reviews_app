# Load the Rails test environment with RSpec helpers
require 'rails_helper'

# Top‑level example group that describes what we’re testing
RSpec.describe 'String Test from Andriu' do
  # Nested group for related examples about basic string equality
  describe 'basic string equality' do

    # 1. Verifies that two identical strings are considered equal
    it 'should match identical strings' do
      expected_string = 'Hello World'
      actual_string   = 'Hello World'

      # Expect the strings to be exactly the same
      expect(actual_string).to eq(expected_string)
    end

    # 2. Ensures that two different strings are *not* equal
    it 'should not match different strings' do
      string_one = 'Hello World'
      string_two = 'Goodbye World'

      # Expect the strings to differ
      expect(string_one).not_to eq(string_two)
    end

    # 3. Checks that string interpolation produces the expected result
    it 'should match strings with interpolation' do
      name     = 'Ruby'
      expected = 'Hello Ruby'
      actual   = "Hello #{name}"   # Interpolates the variable into the string

      # Expect the interpolated string to equal the expected string
      expect(actual).to eq(expected)
    end

    # 4. Demonstrates that string comparison is case‑sensitive
    it 'should be case sensitive' do
      string_lower = 'hello world'
      string_upper = 'HELLO WORLD'

      # The two differently‑cased versions should not match
      expect(string_lower).not_to eq(string_upper)

      # Converting the lowercase string to uppercase should make them equal
      expect(string_lower.upcase).to eq(string_upper)
    end

    # 5. Confirms that empty strings compare equal and are detected as empty
    it 'should handle empty strings' do
      empty_string   = ''
      another_empty  = ''

      # Two empty strings should be equal
      expect(empty_string).to eq(another_empty)

      # The be_empty matcher confirms the string is indeed empty
      expect(empty_string).to be_empty
    end
  end
end
