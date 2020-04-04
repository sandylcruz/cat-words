# frozen_string_literal: true

require 'csv'

# Print welcome message
puts 'Welcome to cat words!'

def load_raw_dictionary
  csv_read_options = { headers: true, skip_blanks: true }
  ('A'..'Z').each_with_object([]) do |letter, accumulator|
    path = "dictionary/#{letter}.csv"
    dictionary_for_letter = CSV.read(path, **csv_read_options)
    dictionary_for_letter.each do |row|
      accumulator.push(row.to_hash)
    end
    accumulator
  end
end

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

puts 'Loading dictionary...'
# Load dictionary as a hash
raw_dictionary = load_raw_dictionary

puts 'Dictionary loaded!'

dictionary_as_hash = create_dictionary_as_hash(raw_dictionary)

# Get user input to choose command
puts 'What command do you want to run? (verify/define/list)'

# Execute action user requested
