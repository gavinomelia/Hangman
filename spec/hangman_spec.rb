require 'spec_helper'
require 'hangman'

RSpec.describe Hangman do
  before(:each) do
    @game = Hangman.new
  end

  it 'initializes with a new word' do
    expect(@game.word).not_to be_nil
  end

  it 'initializes with a word teaser' do
    expect(@game.word_teaser).to eq('_ ' * @game.word.size)
  end

  it 'allows a correct guess' do
    @game.guess('a')
    expect(@game.correct_guesses).to include('a')
  end

  it 'does not allow an incorrect guess' do
    @game.guess('z')
    expect(@game.incorrect_guesses).to include('z')
  end

  it 'ends the game after too many incorrect guesses' do
    6.times { @game.guess('z') }
    expect(@game.game_over?).to be true
  end

  it 'can reveal the current state of the word' do
    @game.guess('a')
    expect(@game.current_state).to eq('_a___')
  end
end