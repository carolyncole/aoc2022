require 'byebug.rb'

class Rock
  attr_reader :shape_map
  attr_accessor :cur_idx_x, :cur_idx_y
  def initialize(map)
    @shape_map = map
    @cur_idx_y = 0
    @cur_idx_x = 0
  end

  def height
    shape_map.size
  end

  def width
    shape_map[0].size
  end

  def to_s
    shape_map.map{|line| line.map(&:to_s).join}.join("\n")
  end
end

class Chamber
  attr_reader :grid, :blows, :blow_refill
  def initialize(blows)
    @grid = []
    @completed_rows = 0
    @blow_refill = blows
    @blows = @blow_refill.clone
  end

  def drop_rock(rock)
    # add rows to grid
    add_rows(rock)
    # add shape to top
    add_rock(rock)
    #puts self
    still_falling = true
    while still_falling
      still_falling = fall(rock)
    end
    
    # puts self
    # puts "--------"
  end

  def still_empty
    grid.select{|row| row == [".",".",".",".",".",".","."] }.count
  end

  def add_rows(rock)
    rows = rock.height + 3-still_empty
    if rows < 0
      (1..rows.abs).each do
        grid.shift
      end
    else
      (1..rows).each do 
        grid.prepend [".",".",".",".",".",".","."]
      end
    end
  end

  def add_rock(rock)
    rock.cur_idx_y = 0
    rock.cur_idx_x = 2
    place(rock)
  end

  def fall(rock)
    blow(rock)
    return false unless falling?(rock)
    erase(rock)
    rock.cur_idx_y += 1
    place(rock)
  end

  def blow(rock)
    @blows = blow_refill.clone if blows.length == 0
    change = blows.shift
    return false unless can_blow?(rock, change)
    erase(rock)
    rock.cur_idx_x += change
    place(rock)
    return true
  end

  def place(rock)
    rock.shape_map.each_with_index do |row, y_idx|
      length = row.size
      row.each_with_index do | char, x_idx|
        loc = rock.cur_idx_x+x_idx
        grid[y_idx+rock.cur_idx_y][loc] = char
      end
    end
  end

  def can_move?(rock, change_x, change_y)
    rock.shape_map.each_with_index do |row, y_idx|
      yloc = y_idx+rock.cur_idx_y + change_y
      return false if yloc >= grid.size
      row.each_with_index do | char, x_idx|
        xloc = rock.cur_idx_x+x_idx+change_x 
        if xloc >= 7 || xloc < 0
          return false 
        end
        part_of_rock = y_idx+change_y < rock.height && x_idx+change_x < rock.width && x_idx+change_x >= 0 && rock.shape_map[y_idx+change_y][x_idx+change_x] == "#"     
        if char == "#" && grid[yloc][xloc] == "#" && !part_of_rock
          return false
        end
      end
    end
    return true
  end

  def falling?(rock)
    can_move?(rock, 0, 1)
  end

  def can_blow?(rock, change)
    can_move?(rock,change, 0)
  end

  def erase(rock)
    rock.shape_map.each_with_index do |row, y_idx|
      row.each_with_index do | char, x_idx|
        loc = rock.cur_idx_x+x_idx
        grid[y_idx+rock.cur_idx_y][loc] = "."
      end
    end
  end

  def to_s
    grid.map do |line| 
      line.join
    end.join("\n")+"\n\n"
  end  

end

shape_array =  [Rock.new([['#','#','#','#']]), 
                Rock.new([['.','#','.'],['#','#','#'],['.','#','.']]),
                Rock.new([['.','.','#'],['.','.','#'],['#','#','#']]),
                Rock.new([['#'],['#'],['#'],['#']]),
                Rock.new([['#','#'],['#','#']])]

shape_array.each{|rock| puts rock }

blows = File.read("example.txt").split("").map{|char| char == "<" ? -1 : 1}
chamber = Chamber.new(blows)

(0..9).each do |idx|
  shape_index = idx % 5
  chamber.drop_rock(shape_array[shape_index])
end

puts chamber
puts chamber.grid.size
puts chamber.still_empty