require 'byebug.rb'

def score(letter)
    if /[A-Z]/.match(letter)
      letter.bytes[0]- 65 + 27
    else
        letter.bytes[0] - 96
    end
end

items = File.read("day3.txt").split("\n")
overlaps = items.map do |line|
                middle = line.length/2 -1
                parta = line[0..middle]
                partb = line[(middle+1)..]
                (parta.split('') & partb.split('')).first
            end
puts overlaps.map{|letter| score(letter)}
puts overlaps.map{|letter| score(letter)}.sum
