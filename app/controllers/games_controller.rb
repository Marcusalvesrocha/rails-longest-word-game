class GamesController < ApplicationController
  VOWELS = %w(A E I O U)

  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    @letters = params[:letters].split
    @word = (params[:word] || "").upcase

    @included = included?(@word, @letters)

    @message = @included ? valid_name(@word) : "Sorry but #{@word} can't be built out of #{@letters.flatten}"
  end

  def valid_name(word)
    response = RestClient.get("https://wagon-dictionary.herokuapp.com/#{word}")
    result = JSON.parse(response)
    result["found"] ? "Congratulation! #{word} is a valid English word!" : "Sorry but #{word} does not seem to be a valid English word..."
  end


  def included?(word, letters)
    word.chars.all? do |l|
      word.count(l) <= letters.count(l)
    end
  end

end
