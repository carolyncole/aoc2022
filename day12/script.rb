require 'byebug.rb'

# Dijkstra code is care of the internet.  Thank you google and tsmsogn !!!
# https://gist.github.com/tsmsogn/ae5e5d76fb04226edf98
# Code between here and the matching comment below was copy pasted!!!!
# Node
class Node
  attr_accessor :id, :edges, :cost, :done

  def initialize(id, edges = [], cost = nil, done = false)
    @id, @edges, @cost, @done = id, edges, cost, done
  end
end

# Edge
class Edge
  attr_accessor :to, :cost

  def initialize(to, cost)
    @to, @cost = to, cost
  end
end

# Dijkstra
class Dijkstra
  attr_accessor :nodes

  def initialize(data)
    @nodes = {}
    data.each do |id, edges|
      edges.map! { |edge| Edge.new(*edge) }
      @nodes[id] = Node.new(id, edges)
    end
  end

  def start(start_id)
    @nodes.each do |id, node|
      node.done = false
      node.cost = node.id == start_id ? 0 : -1
    end

    queue = [@nodes[start_id]]

    until queue.empty?
      queue.sort! { |l, r| r.cost <=> l.cost }
      done_node = queue.pop
      done_node.done = true
      done_node.edges.each do |edge|
        node = @nodes[edge.to]
        cost = done_node.cost + edge.cost
        if node.cost < 0 || cost < node.cost
          node.cost = cost
          queue << node unless queue.include?(node)
        end
      end
    end
  end
end
# Dijkstra code is care of the internet
# https://gist.github.com/tsmsogn/ae5e5d76fb04226edf98
# Code between the above comments here was copy pasted!!!!



def construct_edges(map_grid)
  edges = {}
  max_row = map_grid.length-1
  max_col = map_grid.first.length-1
  (0..(max_row)).each do |row_idx|
    (0..(max_col)).each do |col_idx|
      current =  [row_idx, col_idx]
      current_value = map_grid[row_idx][col_idx]
      edges[current] = []
      edges[current] << [[row_idx+1, col_idx], cost(current_value, map_grid[row_idx+1][col_idx])] if row_idx < max_row
      edges[current] << [[row_idx, col_idx+1], cost(current_value, map_grid[row_idx][col_idx+1])] if col_idx < max_col
      edges[current] << [[row_idx-1, col_idx], cost(current_value, map_grid[row_idx-1][col_idx])] if row_idx > 0
      edges[current] << [[row_idx, col_idx-1], cost(current_value, map_grid[row_idx][col_idx-1])] if col_idx > 0
    end
  end
  edges
end

def cost(value_from, value_to)
  distance = value_to - value_from
  if distance > 1
    cost = 10000
  else
    cost = 1
  end
end

map_data = File.read("input.txt").split("\n")

start_location = [0,0]
end_location = [0,0]

map_grid = map_data.map.with_index do |line, index_y|
             line.split("").map.with_index do |value, index_x|
                if (value == 'S')
                  start_location = [index_y, index_x]
                  0
                elsif (value == 'E')
                  end_location = [index_y,index_x]
                  'z'.ord - 'a'.ord
                else  
                  value.ord - 'a'.ord
                end
              end
            end

puts map_grid.map{|values| values.map{|value| value.to_s.rjust(2,'0')}.join(',')}.join("\n")
                
puts "Start: #{start_location.join(",")} End: #{end_location.join(",")}"



dijkstra = Dijkstra.new(construct_edges(map_grid))
dijkstra.start start_location
puts dijkstra.nodes[end_location].cost

possible_starts = []
max_row = map_grid.length-1
max_col = map_grid.first.length-1
(0..(max_row)).each do |row_idx|
  (0..(max_col)).each do |col_idx|
    if map_grid[row_idx][col_idx] == 0
      possible_starts << [row_idx, col_idx]
    end
  end
end
distances = possible_starts.map do |start_loc|
            dijkstra = Dijkstra.new(construct_edges(map_grid))
            dijkstra.start start_loc
            dijkstra.nodes[end_location].cost
          end

puts distances.min
