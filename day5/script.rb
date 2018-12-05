def process(input)
  # find latest letter first
  #
  # scan / remove mismatched pairs
  #
  # repeat

  chars = input.chars
  input.downcase.chars.sort.uniq.reverse.each do |scan_for|
    idx = 0
    chars.compact!
    while idx < chars.length do
      char = chars[idx]
      next_char_idx = get_next_char_idx(chars, idx)
      next_char = chars[next_char_idx]
      if char && next_char &&
        char.downcase == scan_for &&
        next_char.downcase == scan_for &&
        char != next_char
        chars[idx] = nil
        chars[next_char_idx] = nil
        idx = next_char_idx + 1
      else
        idx += 1
      end
      # p({idx: idx, scan_for: scan_for}) if idx.divmod(10000)[1] == 0
    end
  end
  chars.compact.join
end

def get_next_char_idx(chars, idx)
  next_idx = idx + 1
  until chars[next_idx] || next_idx > chars.length
    next_idx += 1
  end
  next_idx
end

if __FILE__ == $0
  input = File.read('input.txt')
  iteration = 0
  loop do
    output = process(input)
    if output == input
      puts "DONE:"
      puts output
      break
    end
    puts "input length: #{input.length} - output length: #{output.length}"
    input = output
    iteration += 1
    puts "*** ITERATION #{iteration} ***"
  end
end