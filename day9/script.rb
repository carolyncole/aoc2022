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
    attr_reader :tail_positions, :current_head, :current_tail
    def initialize
        @current_head = Node.new(0,0)
        @tail_positions = [Node.new(0,0)]
        @current_tail = @tail_positions[0]
    end

    def move_positions(move)
      #puts "== #{move} =="
      (1..move.length).each do 
        new_head = if move.direction == "R"
                      Node.new(current_head.x+1, current_head.y)
                   elsif move.direction == "L"
                      Node.new(current_head.x-1, current_head.y)
                    elsif move.direction == "U"
                      Node.new(current_head.x, current_head.y+1)
                    elsif move.direction == "D"
                      Node.new(current_head.x, current_head.y-1)
                    end
         new_tail = move_tail(new_head, current_tail)
         @current_head = new_head
         new_index = @tail_positions.find_index(new_tail)
         if new_index.nil?
           tail_positions <<  new_tail 
           @current_tail = new_tail
         else
           @current_tail = @tail_positions[new_index]  
         end
         # puts self
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
      "head: #{current_head} tail: #{current_tail}"
    end
end



move_strings = File.read("input.txt").split("\n")
head_movements = move_strings.map{|move_str| Move.new(move_str) }

map = Map.new()
head_movements.each{|move| map.move_positions(move)}
puts map.tail_positions.count

