def process(input)
  # find latest letter first
  #
  # scan / remove mismatched pairs
  #
  # repeat

  input.downcase.chars.sort.uniq.reverse.each do |scan_for|
    idx = 0
    while idx < input.length do
      char = input.chars[idx]
      next_char = input.chars[idx + 1]
      if char && next_char &&
        char.downcase == scan_for &&
        next_char.downcase == scan_for &&
        char != next_char
        slice_out_chars_at(input, idx)
        idx -= 2
      else
        idx += 1
      end
      puts idx
    end
  end
  input
end

def slice_out_chars_at(input, index)
  input.slice!(index..(index + 1))
end

if __FILE__ == $0
  puts process(File.read('input.txt'))
end