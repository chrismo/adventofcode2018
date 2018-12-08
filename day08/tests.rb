require_relative 'script'

def assert_equals(a, b)
  raise "Expected\n  <#{a}> to equal\n  <#{b}>" unless a == b
  print '.'
end

assert_equals(process('2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2'), 138)