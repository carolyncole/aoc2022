require 'byebug.rb'

calories = File.read("day1.txt").split("\n")
total_calories = []
last = nil
idx = 0
total_calories[idx]=0
calories.each do |calorie|
  if calorie.empty?
    idx+=1
    total_calories[idx]=0
  else
    calorie = calorie.to_i
    total_calories[idx]+=calorie
  end
end 

max_calories = total_calories.max
elf = total_calories.rindex(max_calories)
puts max_calories
puts elf
