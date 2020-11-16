require 'open-uri'

class GamesController < ApplicationController
  def new
    @@array = []
    10.times { @@array << ('A'..'Z').to_a.sample }
    @array = @@array
  end

  def score
    arr = @@array
    letters = build_grid_string(arr)
    word = params[:score].upcase
    chck_contains = check_if_contains(word, arr)
    if chck_contains && json_parse(word)
      @woz = "Congratulations! #{word} is a valid word!"
    elsif chck_contains == true && json_parse(word) == false
      @woz = "Sorry but #{word} does not seem to be a valid English word..."
    elsif chck_contains == false
      @woz = "Sorry but #{word} can't be built out of #{letters}"
    end
  end

  def build_grid_string(arr)
    retstr = ''
    arr.each do |letter|
      retstr << "#{letter}, "
    end
    2.times { retstr[-1] = '' }
    retstr
  end

  def check_if_contains(word, arr)
    i = 0
    stat = true
    while i < word.length do
      if arr.include?(word[i])
        arr.delete_at(arr.index(word[i]))
        i += 1;
      else
        stat = false
        break
      end
    end
    stat
  end

  def json_parse(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    user_serialized = open(url).read
    user = JSON.parse(user_serialized)
    user['found']
  end
end
