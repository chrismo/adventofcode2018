require_relative 'script'

def assert_equals(a, b)
  raise "Expected\n  <#{a}> to equal\n  <#{b}>" unless a == b
end

assert_equals(process('aA'), '')
assert_equals(process('abBA'), '')
assert_equals(process('abAB'), 'abAB')
assert_equals(process('aabAAB'), 'aabAAB')

assert_equals(process('dabAcCaCBAcCcaDA'), 'dabCBAcaDA')
assert_equals(process('dabCBAcaDA'), 'dabCBAcaDA')
