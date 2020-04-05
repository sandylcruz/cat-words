# frozen_string_literal: true

require 'csv'

CAT_KEY_WORDS = %w[cat feline].freeze

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
  csv_read_options = { headers: true, skip_blanks: true }
  ('A'..'Z').each_with_object([]) do |letter, accumulator|
    load_dictionary_for_letter(letter, csv_read_options, accumulator)
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

def cat_like_definition?(definition)
  words = definition.split(' ')
  words.any? { |word| CAT_KEY_WORDS.include?(word) }
end

def cat_word?(definitions)
  definitions.any? { |definition| cat_like_definition?(definition) }
end

def create_cat_dictionary
  puts 'Dictionary is loading...'
  dictionary_as_hash = create_dictionary_as_hash(full_dictionary)

  cat_word_accumulator = {}

  dictionary_as_hash.each do |word, definitions|
    cat_word_accumulator[word] = definitions if cat_word?(definitions)
  end

  puts 'Dictionary loaded!'

  cat_word_accumulator
end

def run
  display_welcome_message

  cat_dictionary = create_cat_dictionary

  puts 'What command do you want to run? (verify/define/list)'
end

run
