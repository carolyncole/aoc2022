require 'byebug.rb'

def parse_stacks(map)
  []
  map_list = map.split("\n")
  stack_names = map_list.pop.split(" ").map(&:strip)
  stacks = stack_names.map{|_name| [] }
  stack_list = map_list.reverse
  stack_list.each do |row| 
    row_items = row.split("").each_slice(4).map{|item| item[1]}
    row_items.each_with_index{|item,idx| stacks[idx] << item unless item == " "}
  end
  return stacks
end

def run_instruction(stacks, instruction)
  parts = instruction.split
  number_of_crates = parts[1].to_i
  from_idx = parts[3].to_i
  to_idx = parts[5].to_i
  (1..number_of_crates).each {stacks[to_idx-1] << stacks[from_idx-1].pop}
end

def run_instruction_multi(stacks, instruction)
  parts = instruction.split
  number_of_crates = parts[1].to_i
  from_idx = parts[3].to_i
  to_idx = parts[5].to_i
  stacks[to_idx-1] += stacks[from_idx-1].pop(number_of_crates)
end


def print_stacks(stacks)
  puts "---------"
  stacks.each_with_index do |stack,idx|
    puts "#{idx+1} #{stack.join(',')}"
  end
end

map, instructions = File.read("input.txt").split("\n\n")
stacks = parse_stacks(map)
print_stacks(stacks)
instructions.split("\n").each do |instruction|
  run_instruction_multi(stacks, instruction)
  print_stacks(stacks)
end

print_stacks(stacks)

puts stacks.map{|stack| stack.last}.join
