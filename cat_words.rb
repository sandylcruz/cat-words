# frozen_string_literal: true

require 'csv'

CAT_KEY_WORDS = %w[felis cat feline].freeze

def display_welcome_message
  puts 'Welcome to cat words!'
end

def display_farewell_message
  puts 'Goodbye =^..^='
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

def format_word(word)
  word.downcase.gsub(/\W+/, '')
end

def cat_like_definition?(definition)
  words = definition.split(' ')
  words.any? { |word| CAT_KEY_WORDS.include?(format_word(word)) }
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

def valid_input?(user_answer)
  %w[define exit list verify].include?(user_answer)
end

def user_cat_word?(word, cat_dictionary)
  cat_dictionary.key?(word)
end

def run_define_command(cat_dictionary)
  puts 'Which cat word do you want to define?'
  user_answer = gets.chomp.capitalize
  unless user_cat_word?(user_answer, cat_dictionary)
    puts "That's not even a cat word. hiss"
  end
  puts "Here is the definition for #{user_answer}:"
  puts cat_dictionary[user_answer]
end

def run_list_command(cat_dictionary)
  puts 'Wow you must really love cats.'
  puts cat_dictionary.keys
  puts "That was all #{cat_dictionary.keys.length} cat words. purr"
end

def run_verify_command(cat_dictionary)
  puts 'Which word do you want to verify for its catness?'
  user_answer = gets.chomp.capitalize
  if user_cat_word?(user_answer, cat_dictionary)
    puts "#{user_answer} is a cat word! =^..^= purr"
  else
    puts "#{user_answer} is not a cat word. hiss"
  end
end

def start_command_interface(cat_dictionary)
  loop do
    puts 'What command do you want to run? (verify/define/list/exit)'
    user_answer = gets.chomp.downcase
    if valid_input?(user_answer)
      puts 'You said define, exit, list, or verify.'
      if user_answer == 'define'
        run_define_command(cat_dictionary)
      elsif user_answer == 'list'
        run_list_command(cat_dictionary)
      elsif user_answer == 'verify'
        run_verify_command(cat_dictionary)
      elsif user_answer == 'exit'
        break
      end
    else
      puts 'Invalid command'
    end
  end
end

def run
  display_welcome_message

  cat_dictionary = create_cat_dictionary

  start_command_interface(cat_dictionary)

  display_farewell_message
end

run
