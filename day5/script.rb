def process(input)
  chars = input.chars
  idx = 0
  while idx < chars.length do
    char = chars[idx]
    next_char_idx = get_next_char_idx(chars, idx)
    next_char = chars[next_char_idx]
    if char && next_char &&
      char.downcase == next_char.downcase &&
      char != next_char then
      chars[idx] = nil
      chars[next_char_idx] = nil
      idx = get_prev_char_idx(chars, idx)
    else
      idx = get_next_char_idx(chars, idx)
    end
  end
  chars.compact.join
end

def get_prev_char_idx(chars, idx)
  return 0 if idx <= 0
  prev_idx = idx - 1
  until chars[prev_idx] || prev_idx == 0
    prev_idx -= 1
  end
  prev_idx
end

def get_next_char_idx(chars, idx)
  next_idx = idx + 1
  until chars[next_idx] || next_idx > chars.length
    next_idx += 1
  end
  next_idx
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