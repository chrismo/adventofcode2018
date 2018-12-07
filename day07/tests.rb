require_relative 'script'

def assert_equals(a, b)
  raise "Expected\n  <#{a}> to equal\n  <#{b}>" unless a == b
  print '.'
end

input = <<~_
Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
Step A must be finished before step B can begin.
Step A must be finished before step D can begin.
Step B must be finished before step E can begin.
Step D must be finished before step E can begin.
Step F must be finished before step E can begin.
_

assert_equals(process(input.split(/\n/)), 'CABDFE')