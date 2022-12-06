require 'byebug.rb'

def score(letter)
    if /[A-Z]/.match(letter)
      letter.bytes[0]- 65 + 27
    else
        letter.bytes[0] - 96
    end
end

pairs = File.read("day4.txt").split("\n")
inside = pairs.count do |line|
            pair1,pair2 = line.split(",")
            range1 = pair1.split("-").map(&:to_i)
            range2 = pair2.split("-").map(&:to_i)
            ((range1[0] <= range2[0]) && (range1[1] >= range2[1])) ||
            ((range2[0] <= range1[0]) && (range2[1] >= range1[1])) ||
            ((range1[0] <= range2[1]) && (range1[0] >= range2[0])) ||
            ((range2[0] <= range1[1]) && (range2[0] >= range1[0])) ||
            ((range1[1] <= range2[1]) && (range1[1] >= range2[0])) ||
            ((range2[1] <= range1[1]) && (range2[1] >= range1[0]))
         end
puts inside