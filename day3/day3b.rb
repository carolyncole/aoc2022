require 'byebug.rb'

def score(letter)
    if /[A-Z]/.match(letter)
      letter.bytes[0]- 65 + 27
    else
        letter.bytes[0] - 96
    end
end

items = File.read("day3.txt").split("\n")
overlaps = items.each_slice(3).map do |line1, line2, line3|
                (line1.split('') & line2.split('') & line3.split('')).first
            end
byebug
puts overlaps.map{|letter| score(letter)}
puts overlaps.map{|letter| score(letter)}.sum
