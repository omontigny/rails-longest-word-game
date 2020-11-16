require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
  @letters = []
  10.times { @letters << ('a'..'z').to_a.sample.upcase }
  end

  def check_nb_letter?(word, array_letters)
    word.upcase.split(//).each do |letter|
      # p "#{letter.upcase} - #{array_letters}"
      if array_letters.include?(letter)
        array_letters.delete_at(array_letters.find_index(letter))
      else
        return false
      end
    end
    return true
  end

  def reset
    session[:score] = 0
  end

  def score
    @word = params[:word]
    @letters = params[:list_letters]
    session[:score] ? @score = session[:score] : @score = 0
    @first_part = "Sorry but "

    if check_nb_letter?(@word, @letters.split(' '))

      result = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{@word}").read)

      if result["found"]
        @first_part = "Congratulations! "
        @message = "is a valid English word!"
        @score += @word.length
        session[:score] = @score
      else
        @message = "does not seem to be a valid English word..."
      end
    else
      # The word cant be built out of the original grid
      @message = "can't be out of the the grid '#{@letters}'"
    end
  end
end

# def calculate_score(time, word_length)
#   # Max Score = 10 , we loos 1 point by 15s and multiply by length of word
#   (10 - (time / 15)) * word_length
# end

# def english_word?(word)
#   # 1. Valider que le mot fourni est valide - use Wagon API
#   # https://wagon-dictionary.herokuapp.com/#{attempt}
#   # => {"found":true,"word":"apple","length":5}
#   result = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{word}").read)
#   return result['found']
# end

# def score_and_message(attempt, grid, score)
#   return [0, "TRY AGAIN! You used a letter not in the grid"] unless check_nb_letter?(attempt, grid)
#   return [0, "TRY AGAIN! Not an english word"] unless english_word?(attempt)

#   [score, "well done"]
# end

# def run_game(attempt, grid, start_time, end_time)
#   # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
#   # 1. Calculter le time
#   running_time = end_time - start_time
#   # 2. Calculer le score
#   score = calculate_score(running_time, attempt.length)
#   score, message = score_and_message(attempt, grid, score)

#   # 5. retourner toutes les infos dans Hash
#   { time: running_time, score: score, message: message }
#   # puts "#{result['found']} - #{result['word']} - #{result['length']}"
# end

# generate_grid(9).join(" ")
# p run_game("apple", %w[T A L H T P E M D], "", "")
