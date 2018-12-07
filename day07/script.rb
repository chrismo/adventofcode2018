class Sequencer
  def initialize(map)
    @map = map
    p @map
  end
  
  def final_order
    queue = origin_step.sort
    sequence = []
    until queue.empty?
      step = queue.shift
      sequence << step
      next_steps = @map.delete(step)
      break if next_steps.nil?
      remove_not_ready(next_steps)
      queue += next_steps
      queue.sort!
    end
    sequence.join
  end

  def remove_not_ready(steps)
    undone_steps = @map.values.flatten.uniq
    steps.delete_if do |step|
      undone_steps.include?(step)
    end
  end

  def origin_step
    (@map.keys - @map.values.flatten.uniq)
  end
end

def process(input)
  hash = {}
  input.map do |ln|
    steps = ln.scan(/Step (\w).*step (\w)/).flatten
    hash[steps.first] ||= []
    hash[steps.first] << steps.last
  end
  hash
  s = Sequencer.new(hash)
  s.final_order
end

def find_prerequisites(hash, step)
  
end

if __FILE__ == $0
  puts "Part 1"
  input = File.readlines('input.txt').map(&:chomp)
  output = process(input)
  p output

  # puts "Part 2"
  # output = process(input)
  # p output
end