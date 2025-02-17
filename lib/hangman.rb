class Hangman
  attr_accessor :word, :word_teaser, :lives

  def initialize
    dictionary = File.readlines('google-10000-english-no-swears.txt')
    @word = dictionary.sample.chomp
    @lives = 6
    @word_teaser = ''
    @word.size.times do
      @word_teaser += '_ '
    end
  end

  def play
    puts 'Welcome to Hangman!'
    puts 'Try to guess the word I\'m thinking of.'
    puts @word_teaser
    while @lives.positive?
      puts 'Guess a letter: '
      guessed_letter = gets.chomp
      guess(guessed_letter)
      puts "Lives left: #{@lives}"
      puts @word_teaser
      draw_stick
      break if game_over?
    end
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
    if @lives <= 0
      puts "Sorry, you lost! The word was: #{@word}"
      return true
    elsif @word.delete(' ') == @word_teaser.delete(' ')
      puts 'Congratulations! You won!'
      return true
    end
    false
  end

  private

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

    puts stick_figure
  end

  def update_teaser(last_guess)
    new_teaser = @word_teaser.split
    new_teaser.each_with_index do |letter, index|
      new_teaser[index] = last_guess if @word[index] == last_guess
    end
    @word_teaser = new_teaser.join(' ')
  end
end