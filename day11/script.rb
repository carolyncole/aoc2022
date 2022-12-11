require 'byebug.rb'

class Monkey
  attr_reader :items, :operation_parts, :divisble, 
              :true_monkey, :false_monkey, :inspections, 
              :operation_method, :by_number
  def initialize(monkey_config)
    lines = monkey_config.split("\n")
    
    @items = lines[1].split(": ")[1].split(", ").map(&:to_i)
    op_parts = lines[2].split("new = ")[1].split(" ")
    if op_parts[0] == "old" && op_parts[2] == "old"
      if op_parts[1] == "+"
        @operation_method =  :operation_add_old_by_old
      else
        @operation_method =  :operation_multiply_old_by_old
      end
    else
      if op_parts[1] == "+"
        @operation_method = :operation_add_old_by
      else 
        @operation_method = :operation_multiply_old_by
      end
      if op_parts[0] == "old"
        @by_number = op_parts[2].to_i
      else
        @by_number = op_parts[0].to_i
      end
    end
    @operation_parts
    @divisble = lines[3].split("divisible by ")[1].to_i
    if lines[4].include?("true")
      @true_monkey = lines[4].split("throw to monkey ")[1].to_i
      @false_monkey = lines[5].split("throw to monkey ")[1].to_i
    else
      byebug
    end
    @inspections = 0
  end

  def turn(monkey_list, lcm)
    @inspections += items.length
    items.each do |item|
      new_item = (run_operation(item)/ 3.0).floor % lcm
      new_monkey = if (new_item % divisble) == 0
                      true_monkey
                    else
                      false_monkey
                    end
      monkey_list[new_monkey].items << new_item
    end
    items.clear
  end

  def turn_part2(monkey_list, lcm)
    @inspections += items.length
    items.each do |item|
      new_item = run_operation(item) % lcm
      new_monkey = if (new_item % divisble) == 0
                      true_monkey
                    else
                      false_monkey
                    end
      monkey_list[new_monkey].items << new_item
    end
    @items.clear
  end

  def operation_multiply_old_by(item)
    item *= by_number
  end

  def operation_add_old_by(item)
    item += by_number
  end

  def operation_add_old_by_old(item)
    item += item
  end

  def operation_multiply_old_by_old(item)
    item *= item
  end


  def run_operation(item)
    send(operation_method,item)
  end

  def to_s
   items.join(", ")
  end
end

monkey_configs = File.read("input.txt").split("\n\n")
monkeys = monkey_configs.map{|config| Monkey.new(config)}
lcm = monkeys.map(&:divisble).reduce(1){ |acc, n| acc.lcm(n) }
monkeys.each{|monkey| puts monkey }
(0..19).each do |round|
  (0..(monkeys.length-1)).each do |index|
    monkeys[index].turn(monkeys, lcm)
  end

  puts "round #{round+1} results"
  monkeys.each{|monkey| puts monkey }
end

max_two =  monkeys.map(&:inspections).max(2)
puts max_two[0] * max_two[1]

monkeys = monkey_configs.map{|config| Monkey.new(config)}
monkey_length = monkeys.length - 1
(0..9999).each do |round|
  (0..monkey_length).each do |index|
    monkeys[index].turn_part2(monkeys, lcm)
  end

  if round == 0 || round == 19 || (round+1) % 1000 == 0
    puts "part 2 round #{round+1} results"
    puts monkeys.map(&:inspections).join(", ")
  end
end

max_two =  monkeys.map(&:inspections).max(2)
puts max_two[0] * max_two[1]
