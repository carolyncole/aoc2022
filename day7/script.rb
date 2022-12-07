require 'byebug.rb'
class File
  attr_reader :size, :name
  def initialize(name, size)
    @size = size.to_i
    @name = name
  end

  def to_i
    size
  end

  def to_s
    "#{name} #{size}"
  end
end

class Directory
  attr_reader :name, :children, :parent
  def initialize(name, parent)
    @children = {}
    @name = name
    @parent  = parent
  end

  def to_i
    children.values.map(&:to_i).sum
  end

  def sum(max, total)
    if to_i < max
      total += to_i
    end
    children.values.each do |child|
      next unless child.is_a? Directory
      total = child.sum(max, total)
    end 
    total
  end

  def find(space_needed)
    return if to_i < space_needed
    found = self
    children.values.each do |child|
      next unless child.is_a? Directory
      child_found = child.find(space_needed)
      found = child_found if !child_found.nil? && child_found.to_i < found.to_i
    end
    found
  end

  def pretty_print(indent)
    puts "#{indent} #{self}"
    children.values.each do |child|
      if child.is_a? Directory
        child.pretty_print(indent+"  ")
      else
        puts "#{indent+"  "} #{child}"
      end
    end
  end

  def to_s
    "#{name} #{to_i}"
  end
end

root = Directory.new("/", nil)

current_dir = root

commands= File.read("input.txt").split("\n")
commands.each do |command|
  if command[0] == "$"
    parts = command.split
    next if parts[1] == "ls"
    if parts[2] == "/"
      current_dir = root
    elsif parts[2] == ".."
      current_dir = current_dir.parent
    else
      # byebug
      # if current_dir.children[parts[2]].nil?
      #   current_dir.children[parts[2]] = Directory.new(parts[2], current)
      # end
      current_dir = current_dir.children[parts[2]]
    end  
  else
    part1, part2 = command.split
    child = if part1 == "dir"
              Directory.new(part2, current_dir)
            else
              File.new(part2,part1)
            end
    current_dir.children[part2]=child
  end
end
puts root


max_size = 100000
sum = root.sum(max_size, 0)

puts "Total with max = #{sum}"


space_open = 70000000 - root.to_i
puts "space used #{ root.to_i}"
puts "space want 30000000"
puts "space open #{space_open}"
space_needed =  30000000 - space_open
puts "root total #{ root.to_i }"
puts "space needed #{ space_needed}"
root.pretty_print("")
found = root.find(space_needed)
byebug
puts "directory to delete #{found}"
