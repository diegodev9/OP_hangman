require 'json'

class Hangman
  attr_accessor :secret_word, :guessed_letters, :incorrect_guesses, :max_attempts

  def initialize(dictionary)
    @dictionary = dictionary.map(&:chomp).select { |word| word.length.between?(5, 12) }
    @secret_word = select_random_word
    @guessed_letters = []
    @tried_letters = []
    @incorrect_guesses = 0
    @max_attempts = 6
  end

  def select_random_word
    @dictionary.sample
  end

  def display_word
    display = @secret_word.chars.map { |char| @guessed_letters.include?(char.downcase) ? char : '_' }.join(' ')
    puts display
  end

  def display_status
    puts "Incorrect guesses left: #{@max_attempts - @incorrect_guesses}"
    puts "Guessed letters: #{@tried_letters.join(', ')}"
  end

  def make_guess(letter)
    letter.downcase!

    puts "You already guessed '#{letter}'. Try again." if @tried_letters.include?(letter)

    if @secret_word.downcase.include?(letter)
      @guessed_letters << letter
      puts 'Correct guess!'
    else
      @tried_letters << letter
      @incorrect_guesses += 1
      puts 'Incorrect guess!' unless letter == 'save' || letter == 'exit'
    end
  end

  def save_game
    game_state = {
      secret_word: @secret_word,
      guessed_letters: @guessed_letters,
      tried_letters: @tried_letters,
      incorrect_guesses: @incorrect_guesses,
      max_attempts: @max_attempts
    }

    File.open('hangman_save.json', 'w') { |file| file.puts game_state.to_json }
    puts 'Game saved!'
  end

  def load_game
    saved_game = JSON.parse(File.read('hangman_save.json'))

    @secret_word = saved_game['secret_word']
    @guessed_letters = saved_game['guessed_letters']
    @tried_letters = saved_game['tried_letters']
    @incorrect_guesses = saved_game['incorrect_guesses']
    @max_attempts = saved_game['max_attempts']

    puts 'Game loaded!'
  end

  def check_word
    @guessed_letters.uniq.sort == @secret_word.downcase.chars.uniq.sort
  end

  def check_attempts
    @incorrect_guesses > @max_attempts
  end

  def play
    loop do
      system('clear')

      display_word
      display_status

      puts "Enter a letter to guess, 'save' to save the game and play later, or 'exit' to quit:"
      input = gets.chomp.downcase
      make_guess(input)

      check_word
      check_attempts
      save_game if input == 'save'

      puts "Congratulations! You guessed the word: #{@secret_word}" if check_word
      puts "Sorry, you're out of attempts. The word was #{@secret_word}" if check_attempts
      puts "Bye!" if input == 'exit'

      break if input == 'save' || input == 'exit' || check_word || check_attempts

      sleep(1)
    end
  end
end

