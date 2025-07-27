require 'rails_helper'

RSpec.describe 'String Test from Andriu' do
  describe 'basic string equality' do

    it 'should match identical strings' do
      expected_string = 'Hello World'
      actual_string   = 'Hello World'

      expect(actual_string).to eq(expected_string)
    end

    it 'should not match different strings' do
      string_one = 'Hello World'
      string_two = 'Goodbye World'

      expect(string_one).not_to eq(string_two)
    end

    it 'should match strings with interpolation' do
      name     = 'Ruby'
      expected = 'Hello Ruby'
      actual   = "Hello #{name}"
      expect(actual).to eq(expected)
    end

    it 'should be case sensitive' do
      string_lower = 'hello world'
      string_upper = 'HELLO WORLD'

      expect(string_lower).not_to eq(string_upper)

      expect(string_lower.upcase).to eq(string_upper)
    end

    it 'should handle empty strings' do
      empty_string   = ''
      another_empty  = ''

      expect(empty_string).to eq(another_empty)

      expect(empty_string).to be_empty
    end
  end
end
