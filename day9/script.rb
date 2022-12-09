require 'byebug.rb'

class Node
    attr_reader :x, :y
    def initialize(x,y)
        @x = x
        @y = y
    end

    def ==(other)
      x == other.x && y==other.y
    end

    def to_s
      "#{x},#{y}"
    end
end

class Move
    attr_reader :direction, :length
    def initialize(move_string)
        @direction, length_str = move_string.split(" ")
        @length = length_str.to_i 
    end

    def to_s
      "#{direction} #{length}"
    end
end

class Map
    attr_reader :tail_positions, :knot_poisitions, :knot_length
    def initialize
        @knot_poisitions = [Node.new(0,0), Node.new(0,0), Node.new(0,0),
                            Node.new(0,0), Node.new(0,0), Node.new(0,0),
                            Node.new(0,0), Node.new(0,0), Node.new(0,0),
                            Node.new(0,0)]
        @knot_length = @knot_poisitions.length
        @tail_positions = [@knot_poisitions[@knot_length-1]]
        @current_tail = @tail_positions[0]
    end

    def move_positions(move)
      puts "== #{move} =="
      (1..move.length).each do 
        new_tail = move_knot_positions(move)
        new_index = @tail_positions.find_index(new_tail)
        if new_index.nil?
          tail_positions <<  new_tail 
          knot_poisitions[knot_length-1] = new_tail
        else
          knot_poisitions[knot_length-1] = @tail_positions[new_index]  
        end
        puts self
     end
    end
    def move_knot_positions(move)
      current_idx = 0
      new_head = move_head(move, knot_poisitions[0])
      knot_poisitions[0] = new_head
      new_tail = nil #out of loop scope so it is still around after the loop
      (1..knot_length-1).each do |current_idx|
        new_tail = move_tail(knot_poisitions[current_idx-1], knot_poisitions[current_idx])
        knot_poisitions[current_idx] = new_tail
      end
      return new_tail
    end

    def move_head(move, current_head)
      if move.direction == "R"
        Node.new(current_head.x+1, current_head.y)
      elsif move.direction == "L"
        Node.new(current_head.x-1, current_head.y)
      elsif move.direction == "U"
        Node.new(current_head.x, current_head.y+1)
      elsif move.direction == "D"
        Node.new(current_head.x, current_head.y-1)
      end
    end

    def move_tail(current_head, current_tail)
      location_diff_x = current_head.x - current_tail.x
      location_diff_y = current_head.y - current_tail.y
      return current_tail if location_diff_x.abs <= 1 && location_diff_y.abs <=1

      new_x = if location_diff_x == 0
                current_tail.x
              elsif location_diff_x < 0
                current_tail.x - 1
              else
                current_tail.x + 1
              end
      new_y = if location_diff_y == 0 
                 current_tail.y
              elsif location_diff_y < 0
                 current_tail.y - 1
              else
                 current_tail.y + 1
               end
      Node.new(new_x,new_y)
    end

    def to_s
      knot_poisitions.join(", ")
    end
end



move_strings = File.read("input.txt").split("\n")
head_movements = move_strings.map{|move_str| Move.new(move_str) }

map = Map.new()
head_movements.each{|move| map.move_positions(move)}
puts map.tail_positions.count

