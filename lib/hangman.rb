class Hangman
  attr_reader :word, :word_teaser, :lives

  def initialize
    dictionary = File.readlines('google-10000-english-no-swears.txt')
    @word = dictionary.sample.chomp
    @lives = 7
    @word_teaser = ''
    @word.size.times do
      @word_teaser += '_ '
    end
    puts 'Welcome to Hangman!'
    puts 'Try to guess the word I\'m thinking of.'
    p @word
    puts @word_teaser
  end

  def word
    @word
  end


end