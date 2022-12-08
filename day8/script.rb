require 'byebug.rb'

def scenic_score(map, x, y, range, xmove)
  tree = map[y][x]
  score = 0
  range.each do |new_index|
    other_tree = if xmove
                   map[y][new_index]
                 else
                   map[new_index][x]
                 end
    score += 1
    break if other_tree >= tree
  end
  score
end

def scenic_score_left(map, x, y)
  scenic_score(map, x, y, (x-1).downto(0), true)
end

def scenic_score_right(map, x, y)
  scenic_score(map, x, y, (x+1)..(map[y].count-1), true)
end

def scenic_score_up(map, x, y)
  scenic_score(map, x, y, ((y-1).downto(0)), false)
end

def scenic_score_down(map, x, y)
  scenic_score(map, x, y, ((y+1)..(map.count-1)), false)
end


def visible_left(map, x, y)
  tree = map[y][x]
  visible = true
  (0..x-1).each do |new_x|
    other_tree = map[y][new_x]
    if other_tree >= tree
      visible = false
      break
    end
  end
  visible
end

def visible_right(map, x, y)
  tree = map[y][x]
  visible = true
  (x+1..(map[y].count-1)).each do |new_x|
    other_tree = map[y][new_x]
    if other_tree >= tree
      visible = false
      break
    end
  end
  visible
end

def visible_up(map, x, y)
  tree = map[y][x]
  visible = true
  (0..y-1).each do |new_y|
    other_tree = map[new_y][x]
    if other_tree >= tree
      visible = false
      break
    end
  end
  visible
end

def visible_down(map, x, y)
  tree = map[y][x]
  visible = true
  (y+1..(map.count-1)).each do |new_y|
    other_tree = map[new_y][x]
    if other_tree >= tree
      visible = false
      break
    end
  end
  visible
end

rows = File.read("input.txt").split
map = rows.map{|row| row.split("").map(&:to_i)}

map.each{|row| puts row.join(",")}
total_visible = 0
map.each_with_index do |row, y|
  row.each_with_index do |tree, x|
    if x==0 || y==0 || y==map.count || x==row.count
      total_visible+=1
    else
      if visible_up(map, x, y) || visible_down(map, x, y) ||
        visible_left(map, x, y) || visible_right(map, x, y)
        total_visible+=1
      end
    end
  end
end
puts "total visible #{total_visible}"

map = rows.map{|row| row.split("").map(&:to_i)}
scenic_map = map.map.with_index do |row, y|
               row.map.with_index do |tree, x|
                scenic_score_down(map, x, y) * scenic_score_up(map, x, y) *
                  scenic_score_left(map, x, y) * scenic_score_right(map, x, y)
               end
             end
scenic_map.each{|row| puts row.join(",")}

puts "Max view= #{scenic_map.map{|row| row.max }.max}"
