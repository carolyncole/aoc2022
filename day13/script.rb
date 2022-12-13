require 'byebug.rb'
require 'json'

def correct_order?(pair_str)
  pair_strs = pair_str.split("\n")
  pairs = pair_strs.map{|pair| JSON.parse pair}
  puts "-------"
  result =  pair_in_correct_order(pairs[0],pairs[1])
  puts "result: #{result}"
  puts "-------"
  result[:result]
end

def pair_in_correct_order(part1, part2)
  puts "Compare #{part1} vs #{part2}" 
  if part1.is_a?(Integer) && part2.is_a?(Integer)
    puts "Right side is smaller, so inputs are not in the right order" if part2 < part1
    return {continue: part1 == part2, result: part1 <= part2}
  end
  if part2.nil?
    puts "Right side ran out of items, so inputs are not in the right order"
    return {continue: false, result: false}
  end
  if part1.nil?
    puts "Left side ran out of items, so inputs are in the right order"
    return {continue: false, result: true}
  end

  part1 = Array(part1)
  part2 = Array(part2)
  part1.each_with_index do |value1, index|
    value2 = part2[index]
    result = pair_in_correct_order(value1, value2)
    return result unless result[:continue]
  end
  {continue: true, result: true}
end

pairs = File.read("input.txt").split("\n\n")
correct_order = pairs.map.with_index{|pair, index| correct_order?(pair) }

sum_indicies=0
correct_order.each_with_index do |correct, index|
  sum_indicies+=(index+1) if correct
end

puts sum_indicies