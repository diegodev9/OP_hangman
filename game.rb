require_relative 'lib/hangman'

def start_game(dictionary)
  puts "Welcome to Hangman!"
  hangman_game = Hangman.new(dictionary)

  if File.exist?('hangman_save.json')
    puts "Do you want to start a new game or load a saved game? (new/load)"
    choice = gets.chomp.downcase

    hangman_game.load_game if choice == 'load'
  end

  hangman_game.play
end

file = 'dictionary/google-10000-english-no-swear.txt'
dictionary = File.readlines(file) if File.exist?(file)

start_game(dictionary)
