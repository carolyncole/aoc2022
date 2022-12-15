require 'byebug.rb'

class Map
    attr_reader :filled_locations, :max_x, :min_x, :max_y, :dropped_sand
    def initialize(rock_formations)
      @filled_locations = []

      rock_formations.each do |formation|
         locations = formation.split(" -> ").map{|loc| loc.split(",").map(&:to_i)}
         locations.each_cons(2) do |start_loc, end_loc|
            start_y = start_loc[1]
            start_x = start_loc[0]
            end_y = end_loc[1]
            end_x = end_loc[0]
            if start_x > end_x || start_y > end_y
                end_y = start_loc[1]
                end_x = start_loc[0]
                start_y = end_loc[1]
                start_x = end_loc[0]
            end
            (start_y..end_y).each do |y|
              (start_x..end_x).each do |x|
                @filled_locations << [x,y]
              end
            end
         end
      end

      @max_x = filled_locations.map{|loc|loc[0]}.max
      @max_y = filled_locations.map{|loc|loc[1]}.max
      @min_x = filled_locations.map{|loc|loc[0]}.min
      @dropped_sand = 0
    end

    def min_y
      filled_locations.map{|loc|loc[1]}.min
    end

    def to_s
      ((min_y-1)..(max_y+1)).map do |y|
        ((min_x-1)..(max_x+1)).map do |x|
          filled_locations.include?([x,y]) ? "#" : "."
        end.join("")
      end.join("\n")
    end


    def drop_sand(sand_loc)
      if sand_loc[1] > max_y
        return -1 # the abys        
      else
        new_spot_down = [sand_loc[0],sand_loc[1]+1]
        if filled_locations.include?(new_spot_down)
          new_spot_left = [sand_loc[0]-1,sand_loc[1]+1]
          if filled_locations.include?(new_spot_left)
            new_spot_right = [sand_loc[0]+1,sand_loc[1]+1]
            if filled_locations.include?(new_spot_right)
              @dropped_sand+=1
              filled_locations << sand_loc # at rest
              return 1
            else
              drop_sand(new_spot_right)
            end
          else
            drop_sand(new_spot_left)
          end
        else
          drop_sand(new_spot_down) 
        end
      end
    end
end

rock_formations = File.read("input.txt").split("\n")
rock_map = Map.new(rock_formations)
puts rock_map.to_s
puts rock_map.max_x
puts rock_map.max_y
puts 0.5*rock_map.max_x*rock_map.max_y
# result = 1
# while (result == 1)
#     result = rock_map.drop_sand([500,rock_map.min_y-1])
# end

# puts rock_map.dropped_sand
# rock_formations << "#{rock_map.min_x-rock_map.max_y-2},#{rock_map.max_y+2} -> #{rock_map.max_x+rock_map.max_y+2},#{rock_map.max_y+2}"
# rock_map = Map.new(rock_formations)
# puts rock_map.to_s

# result = 1
# while (result == 1)
#     result = rock_map.drop_sand([500,rock_map.min_y-1])
#     result = 0 if rock_map.filled_locations.include?([500,0])
#     puts rock_map.dropped_sand
# end


