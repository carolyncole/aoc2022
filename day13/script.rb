require 'byebug.rb'
require 'json'

def correct_order?(pair_str)
  pair_strs = pair_str.split("\n")
  pairs = pair_strs.map{|pair| JSON.parse pair}
  correct =  pair_in_correct_order(pairs[0],pairs[1])
  puts correct
  correct
end

def pair_in_correct_order(part1, part2)
  return part1 <= part2 if part1.is_a?(Integer) && part2.is_a?(Integer)
  return false if part1.is_a?(Array) && part2.is_a?(Array) && part1.length > part2.length
  return true if part2.nil?

  part1 = Array(part1)
  part2 = Array(part2)
  part1.each_with_index do |value1, index|
    value2 = part2[index]
    correct = pair_in_correct_order(value1, value2)
    return false unless correct
  end
  true
end

pairs = File.read("example.txt").split("\n\n")
correct_order = pairs.map{|pair| correct_order?(pair) }

sum_indicies=0
correct_order.each_with_index do |correct, index|
  sum_indicies+=(index+1) if correct
end

puts sum_indicies