require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @voewls = Array.new(2) { %w[a e i o u].sample }
    @consonents = Array.new(7) {(('a'..'z').to_a. - @voewls).sample }
    @letters = [@voewls, @consonents].flatten.shuffle
  end

  def score
    # raise
    @letters = params[:letters]
    @attempt = params[:guess]
    if included?(@attempt, @letters) && valid(@attempt)
      @result = "Congratulations! #{@attempt.upcase} is a valid English word"
    elsif !included?(@attempt, @letters)
      @result = "Sorry but #{@attempt.upcase} can't be built out of [#{@letters}]"
    elsif !valid(@attempt)
      @result = "Sorry but #{@attempt.upcase} does not seem to be a valid English word"
    end
  end

  private

  def included?(attempt, grid)
    attempt.chars.all? do |letter|
      attempt.count(letter) <= grid.count(letter)
    end
  end


  def valid(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    user = URI.open(url).read
    json = JSON.parse(user)
    json['found']
  end
end
