require 'spec_helper'
require 'hangman'

RSpec.describe Hangman do
  before(:each) do
    File.delete(Hangman::SAVE_FILE_PATH) if File.exist?(Hangman::SAVE_FILE_PATH)
    @game = Hangman.new
  end

  it 'initializes with a new word' do
    expect(@game.word).not_to be_nil
  end

  it 'initializes with a word teaser' do
    expect(@game.word_teaser).to eq('_ ' * @game.word.size)
  end

  it 'allows a correct guess' do
    @game.word = 'apple'
    @game.guess('a')
    expect(@game.word_teaser).to include('a')
  end

  it 'does not allow an incorrect guess' do
    @game.word = 'apple'
    @game.guess('z')
    expect(@game.lives).to eq(5)
  end

  it 'ends the game after too many incorrect guesses' do
    7.times { @game.guess('z') }
    expect(@game.game_over?).to be true
  end

  it 'ends the game after guessing the word' do
    @game.word = 'apple'
    @game.word_teaser = '_ _ _ _ _'
    @game.guess('a')
    @game.guess('p')
    @game.guess('l')
    @game.guess('e')
    expect(@game.game_over?).to be true
    expect(@game.word_teaser).to eq('a p p l e')
  end

  it 'saves the game' do
    @game.send(:save_game)
    expect(File.exist?('saves/saved_game.yaml')).to be true
  end

  it 'loads a saved game' do
    @game.word = 'apple'
    @game.word_teaser = 'a _ _ _ _'
    @game.lives = 5
    @game.send(:save_game)
    @game.send(:load_game)
    expect(@game.word).to eq('apple')
    expect(@game.word_teaser).to eq('a _ _ _ _')
    expect(@game.lives).to eq(5)
  end
end