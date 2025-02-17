require 'YAML'

class Hangman
  SAVE_FILE_PATH = 'saves/saved_game.yaml'.freeze
  DICTIONARY_FILE_PATH = 'google-10000-english-no-swears.txt'.freeze

  attr_accessor :word, :word_teaser, :lives

  def initialize
    if File.exist?(SAVE_FILE_PATH)
      load_game
    else
      start_new_game
    end
  end

  def play
    display_welcome_message
    while @lives.positive?
      guessed_letter = prompt_for_guess
      handle_guess(guessed_letter)
      display_game_status
      break if game_over?
    end
  end

  def display_welcome_message
    puts 'Welcome to Hangman!'
    puts 'To save the game at any point, type "save".'
    puts 'Try to guess the word I\'m thinking of.'
    puts @word_teaser
  end

  def prompt_for_guess
    puts 'Guess a letter: '
    gets.chomp
  end

  def handle_guess(guessed_letter)
    if guessed_letter == 'save'
      save_game
      puts 'Game saved. Exiting...'
      exit
    else
      guess(guessed_letter)
    end
  end

  def display_game_status
    puts "Lives left: #{@lives}"
    puts @word_teaser
    draw_stick
  end

  def guess(letter)
    if @word.include?(letter)
      puts "Good guess! #{letter} is in the word."
      update_teaser(letter)
    else
      puts "Sorry, #{letter} is not in the word."
      @lives -= 1
    end
  end

  def game_over?
    lost? || won?
  end

  private

  def start_new_game
    dictionary = File.readlines(DICTIONARY_FILE_PATH)
    @word = dictionary.sample.chomp
    @lives = 6
    @word_teaser = '_ ' * @word.size
  end

  def load_game
    saved_game = File.open(SAVE_FILE_PATH, 'r') { |file| file.read }
    loaded_game = YAML.safe_load(saved_game, permitted_classes: [Hangman])
    @word = loaded_game.word
    @word_teaser = loaded_game.word_teaser
    @lives = loaded_game.lives
  end

  def save_game
    Dir.mkdir('saves') unless Dir.exist?('saves')
    File.open(SAVE_FILE_PATH, 'w') do |file|
      file.puts YAML.dump(self)
    end
  end

  def draw_stick
    stick_figure = [
      '  _______',
      ' |      |',
      ' |      O',
      ' |     /|\\',
      ' |     / \\',
      ' |',
      ' |__________'
    ]

    update_stick_figure(stick_figure)
    puts stick_figure
  end

  def update_stick_figure(stick_figure)
    case @lives
    when 6
      stick_figure[2] = ' |'
      stick_figure[3] = ' |'
      stick_figure[4] = ' |'
    when 5
      stick_figure[3] = ' |'
      stick_figure[4] = ' |'
    when 4
      stick_figure[3] = ' |      |'
      stick_figure[4] = ' |'
    when 3
      stick_figure[3] = ' |     /|'
      stick_figure[4] = ' |'
    when 2
      stick_figure[3] = ' |     /|\\'
      stick_figure[4] = ' |'
    when 1
      stick_figure[4] = ' |     /'
    when 0
      # stick_figure remains unchanged
    end
  end

  def update_teaser(last_guess)
    @word_teaser = @word_teaser.split.each_with_index.map do |letter, index|
      @word[index] == last_guess ? last_guess : letter
    end.join(' ')
  end

  def lost?
    if @lives <= 0
      puts "Sorry, you lost! The word was: #{@word}"
      true
    else
      false
    end
  end

  def won?
    if @word.delete(' ') == @word_teaser.delete(' ')
      puts 'Congratulations! You won!'
      true
    else
      false
    end
  end
end
