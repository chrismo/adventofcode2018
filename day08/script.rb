# Specifically, a node consists of:
#
# - A header, which is always exactly two numbers:
#   - The quantity of child nodes.
#   - The quantity of metadata entries.
# - Zero or more child nodes (as specified in the header).
# - One or more metadata entries (as specified in the header).

# 2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
# A----------------------------------
#     B----------- C-----------
#                      D-----

class Node
  def initialize(input)
    @input = input
    @children = []
    process
  end

  def process
    child_count, metadata_count = @input.shift(2).map(&:to_i)
    child_count.times do |i|
      @children << Node.new(@input)
    end

    @metadata = @input.shift(metadata_count).map(&:to_i)
  end

  def metadata
    (@metadata.dup +
      @children.map(&:metadata)).flatten
  end

  def metadata_as_pointers
    if @children.empty?
      metadata
    else
      @metadata.map do |child_idx|
        @children[child_idx - 1]
      end.compact.map(&:metadata_as_pointers)
    end
  end
end

if __FILE__ == $0
  puts "Part 1"
  input = File.read('input.txt').chomp
  n = Node.new(input.split(' '))
  p n.metadata.sum

  puts "Part 2"
  n = Node.new(input.split(' '))
  p n.metadata_as_pointers.flatten.sum
end