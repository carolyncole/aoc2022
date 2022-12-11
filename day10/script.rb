require 'byebug.rb'

class Command
  attr_reader :noop, :num
  def initialize(command_str)
    command, number_str = command_str.split
    @noop = number_str.nil?
    @num =  number_str.to_i
  end

  def values
    if noop
      [0]
    else
      [0,num]
    end
  end
end

command_strings = File.read("input.txt").split("\n")
commands = command_strings.map {|command_str| Command.new(command_str)}
values = []
commands.each do |command|
  values+=(command.values)
end
strengths = []
total = 1
print_index = [20,60,100,140,180,220]
total_at_indexes = print_index.map{|index| (values[0..index-1].sum+1)}
puts total_at_indexes
total_at_indexes = print_index.map{|index| (values[0..index-2].sum+1)*index}
puts total_at_indexes.sum

screen = (1..280).map do |cycle|
  xregistry = if cycle >=2
                values[0..cycle-2].sum+1
              else
                1
              end
  sprite_locations = [xregistry-1,xregistry,xregistry+1]
  screen_position = (cycle-1) % 40 % 280
  puts "cycle: #{cycle} #{screen_position} xregistry: #{xregistry}, sprite: #{sprite_locations.join(",")}"
  if (sprite_locations).include?(screen_position)
    "#"
  else  
    "."
  end
end

puts screen[0..39].join("")
puts screen[40..79].join("")
puts screen[80..119].join("")
puts screen[120..159].join("")
puts screen[160..199].join("")
puts screen[200..239].join("")

