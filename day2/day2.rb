require 'byebug.rb'

def score2(move)
  if move[0] == "A" # Rock
    if move[2] == "Y" # Rock
      1+3
    elsif move[2] == "Z" # Paper
      2+6
    elsif move[2] == "X" # Scissors
      3+0
    end
  elsif move[0] == "B" # Paper
    if move[2] == "X" # Rock
      1+0
    elsif move[2] == "Y" # Paper
      2+3
    elsif move[2] == "Z" # Scissors
      3+6
    end
  elsif move[0] == "C" # Scissors
    if move[2] == "Z" # Rock
      1+6
    elsif move[2] == "X" # Paper
      2+0
    elsif move[2] == "Y" # Scissors
      3+3
    end
  end
end

def score(move)
    if move[0] == "A" # Rock
      if move[2] == "X" # Rock
        1+3
      elsif move[2] == "Y" # Paper
        2+6
      elsif move[2] == "Z" # Scissors
        3+0
      end
    elsif move[0] == "B" # Paper
      if move[2] == "X" # Rock
        1+0
      elsif move[2] == "Y" # Paper
        2+3
      elsif move[2] == "Z" # Scissors
        3+6
      end
    elsif move[0] == "C" # Scissors
      if move[2] == "X" # Rock
        1+6
      elsif move[2] == "Y" # Paper
        2+0
      elsif move[2] == "Z" # Scissors
        3+3
      end
    end
end

moves = File.read("day2.txt").split("\n")
tally = moves.tally

scores = tally.keys.map{|move| score2(move)*tally[move]}
puts scores.sum
