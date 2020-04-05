# frozen_string_literal: true

require 'csv'

def display_welcome_message
  puts 'Welcome to cat words!'
end

def load_dictionary_for_letter(letter, csv_read_options, accumulator)
  path = "dictionary/#{letter}.csv"
  dictionary_for_letter = CSV.read(path, **csv_read_options)
  dictionary_for_letter.each do |row|
    accumulator.push(row.to_hash)
  end
  accumulator
end

def full_dictionary
  puts 'Loading dictionary...'

  csv_read_options = { headers: true, skip_blanks: true }
  full_dictionary = ('A'..'Z').each_with_object([]) do |letter, accumulator|
    load_dictionary_for_letter(letter, csv_read_options, accumulator)
  end
  puts 'Dictionary loaded!'

  full_dictionary
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

def run
  display_welcome_message

  dictionary_as_hash = create_dictionary_as_hash(full_dictionary)

  puts 'What command do you want to run? (verify/define/list)'
end

run
