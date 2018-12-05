def process(input)
  chars = input.chars
  idx = 0
  while idx < chars.length do
    idx = 0 if idx < 0
    char = chars[idx]
    next_char = chars[idx + 1]
    if char && next_char && char.downcase == next_char.downcase && char != next_char
      chars[idx] = nil
      chars[idx + 1] = nil
      chars.compact!
      idx -= 1
    else
      idx += 1
    end
  end
  chars.join
end

if __FILE__ == $0
  puts "Part 1"
  input = File.read('input.txt')
  output = process(input)
  puts "output length: #{output.length}"
  puts output

  puts "Part 2"
  res = {}
  ('a'..'z').each do |filter_char|
    print '.'
    filtered_input = input.dup.gsub(/#{filter_char}/i, "")
    output = process(filtered_input)
    res[filter_char] = output
  end
  puts
  shortest = res.min_by { |filter_char, out| out.length }
  p shortest
  puts shortest.last.length
end