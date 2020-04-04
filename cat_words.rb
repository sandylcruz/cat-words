# frozen_string_literal: true

require 'csv'

# Print welcome message
puts 'Welcome to cat words!'

# Load dictionary as a hash
raw_dictionary = CSV.read('dictionary.csv', headers: true)

def create_dictionary_as_hash(dictionary_as_array)
  dictionary_as_hash = Hash.new { |hash, key| hash[key] = [] }
  dictionary_as_array.each_with_object(dictionary_as_hash) do |row, accumulator|
    word = row['word']
    definition = row['definition']
    current_definitions = accumulator[word]
    current_definitions.push(definition)
    accumulator
  end
end

dictionary_as_hash = create_dictionary_as_hash(raw_dictionary)

# Get user input to choose command
puts 'What command do you want to run? (verify/define/list)'

# Execute action user requested
