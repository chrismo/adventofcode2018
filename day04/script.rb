class Parser
  attr_reader :data

  def initialize(lines)
    @lines = lines
    parse
  end

  def most_sleepy_guard
    @data.max_by { |id, mins| mins.keys.length }.first
  end

  def most_sleepy_minute_for_guard(id)
    @data[id].max_by { |min, dates| dates.length }.first
  end

  def most_sleepy_minute_by_any_guard
    result = @data.map do |id, mins|
      [id,
       mins.map do |min, dates|
         [min, dates.length]
       end.max_by do |min, length|
         length
       end
      ]
    end.max_by do |id, max_min_ary|
      max_min_ary.last
    end
    [result.first, result.last.first]
  end

  private

  def parse
    @data = Hash.new
    guard_id = asleep_min = nil
    @lines.sort.each do |ln|
      case ln
      when /Guard/
        guard_id = ln.scan(/#(\d+)/).join
      when /falls/
        _, asleep_min = parse_date(ln)
      when /wakes/
        date, wake_min = parse_date(ln)
        (asleep_min...wake_min).each do |min|
          data[guard_id] ||= {}
          data[guard_id][min] ||= []
          data[guard_id][min] << date
        end
      else
        raise "unexpected line #{ln}"
      end
    end
  end

  def parse_date(ln)
    date, hour_min = ln.scan(/\[(.*)\]/).join.split(' ')
    [date, hour_min.split(':').last]
  end
end

if __FILE__ == $0
  b = Parser.new(File.readlines('input.txt'))
  most_sleepy_guard = b.most_sleepy_guard
  most_sleepy_guard
  most_sleepy_minute = b.most_sleepy_minute_for_guard(most_sleepy_guard)
  puts "Part 1"
  p({guard: most_sleepy_guard, minute: most_sleepy_minute,
     result: most_sleepy_guard.to_i * most_sleepy_minute.to_i})
  puts '---'
  puts "Part 2"
  guard_id, min = b.most_sleepy_minute_by_any_guard
  p({guard: guard_id, minute: min, result: guard_id.to_i * min.to_i})
end
