require_relative 'script'

def assert_equals(a, b)
  raise "Expected\n  <#{a}> to equal\n  <#{b}>" unless a == b
  print '.'
end

input = [
  [1, 1],
  [1, 6],
  [8, 3],
  [3, 4],
  [5, 5],
  [8, 9],
]

assert_equals(largest_non_infinite_region(input), 17)
assert_equals(largest_region_with_closest_distances(input, 32), 16)