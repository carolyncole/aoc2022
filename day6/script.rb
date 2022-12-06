require 'byebug.rb'

bytes= File.read("input.txt").split("")
start_idx = 0
bytes.each_with_index do |_val,idx|
  #byebug
  if bytes[idx..idx+13].tally.values.max == 1
    start_idx = idx
    break
  end
end
puts bytes.join("")
puts start_idx + 14