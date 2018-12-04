require 'set'

class Claim
  attr_accessor :id, :x, :y, :w, :h

  def initialize(line)
    @id, _ = line.scan(/#(\d+)/).flatten
    @x, @y = line.scan(/(\d+),(\d+)/).flatten
    @w, @h = line.scan(/(\d+)x(\d+)/).flatten
    @x = x.to_i
    @y = y.to_i
    @w = w.to_i
    @h = h.to_i
  end

  def all_coords
    @all_coords ||= [].tap do |result|
      x.upto(x + (w - 1)) do |coord_x|
        y.upto(y + (h - 1)) do |coord_y|
          result << [coord_x, coord_y]
        end
      end
    end
  end

  def intersects?(other_claim)
    !intersecting_coords(other_claim).empty?
  end

  def intersecting_coords(other_claim)
    self.all_coords & other_claim.all_coords
  end
end

class ClaimsCompare
  attr_reader :multi_claimed_coords, :overlapping_claims

  def initialize(claims)
    @claims = claims
    execute
  end

  def execute
    @multi_claimed_coords = Set.new
    @overlapping_claims = Set.new
    a_inc = 0
    @claims.each do |a_claim|
      @claims.each do |b_claim|
        next if a_claim == b_claim
        if a_claim.intersects?(b_claim)
          @multi_claimed_coords += a_claim.intersecting_coords(b_claim)
          @overlapping_claims += [a_claim, b_claim]
        end
      end
      a_inc += 1
      puts "#{a_inc.to_f / @claims.length.to_f}% done"
    end
  end

  def overlapping_sq_inches
    @multi_claimed_coords.length
  end

  def non_overlapping_claims
    Set.new(@claims) - @overlapping_claims
  end
end

def execute
  claims = File.readlines("input.txt").map { |ln| Claim.new(ln) }
  cc = ClaimsCompare.new(claims)
  p cc.overlapping_sq_inches
  p cc.non_overlapping_claims.map(&:id)
end

def assert_equals(a, b)
  raise "Expected <#{a}> to equal <#{b}>" unless a == b
end

def diagnostics
  diagnostic_inputs = ['#1 @ 1,3: 4x4',
                       '#2 @ 3,1: 4x4',
                       '#3 @ 5,5: 2x2']

  c1 = Claim.new(diagnostic_inputs[0])
  c2 = Claim.new(diagnostic_inputs[1])
  c3 = Claim.new(diagnostic_inputs[2])

  assert_equals(c3.all_coords, [[5, 5], [5, 6], [6, 5], [6, 6]])
  assert_equals(c1.intersects?(c2), true)
  assert_equals(c2.intersects?(c1), true)
  assert_equals(c1.intersects?(c3), false)
  assert_equals(c2.intersects?(c3), false)

  cc = ClaimsCompare.new([c1, c2, c3])
  p [c1.all_coords | c2.all_coords]
  assert_equals(cc.overlapping_sq_inches, 4)
  assert_equals(cc.non_overlapping_claims.map(&:id), ['3'])

  diagnostic_inputs = ['#1 @ 1,1: 1x1',
                       '#2 @ 1,1: 1x1',
                       '#3 @ 1,1: 1x1']

  cc = ClaimsCompare.new(diagnostic_inputs.map { |ln| Claim.new(ln) })
  assert_equals(cc.overlapping_sq_inches, 1)

  diagnostic_inputs = ['#1 @ 1,1: 2x2',
                       '#2 @ 2,1: 2x3',
                       '#3 @ 3,2: 1x2']

  cc = ClaimsCompare.new(diagnostic_inputs.map { |ln| Claim.new(ln) })
  assert_equals(cc.overlapping_sq_inches, 4)
end

diagnostics

execute