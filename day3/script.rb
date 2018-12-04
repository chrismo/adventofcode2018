require 'set'
# require 'profile'

class Rect
  attr_reader :x, :y, :w, :h, :left, :top, :right, :bottom

  def self.nil_rect
    @nil_rect ||= self.new(0, 0, 0, 0)
  end

  def initialize(x, y, w, h)
    @x = x
    @y = y
    @w = w
    @h = h
    @left = x
    @top = y
    @right = x + w
    @bottom = y + h
  end

  def intersection(other)
    i_left = [left, other.left].max
    i_right = [right, other.right].min

    i_top = [top, other.top].max
    i_bottom = [bottom, other.bottom].min

    return Rect.nil_rect unless i_left < i_right && i_top < i_bottom
    Rect.new(i_left, i_top, (i_right - i_left), (i_bottom - i_top))
  end

  def intersects?(other)
    intersection(other) != Rect.nil_rect
  end

  def to_s
    "origin: #{x},#{y} dimensions: #{w}x#{h}"
  end
end

class Claim
  attr_reader :id, :rect

  def initialize(line)
    @id, _ = line.scan(/#(\d+)/).flatten
    x, y = line.scan(/(\d+),(\d+)/).flatten.map(&:to_i)
    w, h = line.scan(/(\d+)x(\d+)/).flatten.map(&:to_i)
    @rect = Rect.new(x, y, w, h)
  end

  def intersects?(other_claim)
    intersecting_rect(other_claim) != Rect.nil_rect
  end

  def intersecting_rect(other_claim)
    rect.intersection(other_claim.rect)
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
          @multi_claimed_coords += a_claim.intersecting_rect(b_claim)
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

def assert_equals(a, b)
  raise "Expected <#{a}> to equal <#{b}>" unless a == b
end

def rect_diagnostics
  assert_equals(Rect.new(0, 0, 1, 1).intersects?(Rect.new(1, 1, 1, 1)), false)
  assert_equals(Rect.new(0, 0, 2, 1).intersects?(Rect.new(1, 1, 1, 1)), false)
  assert_equals(Rect.new(0, 0, 2, 2).intersects?(Rect.new(1, 1, 1, 1)), true)
  assert_equals(Rect.new(0, 0, 4, 4).intersects?(Rect.new(1, 1, 1, 1)), true)
  assert_equals(Rect.new(1, 1, 1, 1).intersects?(Rect.new(1, 1, 1, 1)), true)
  assert_equals(Rect.new(1, 1, 2, 2).intersects?(Rect.new(0, 0, 2, 2)), true)
  assert_equals(Rect.new(4, 4, 2, 2).intersects?(Rect.new(0, 0, 2, 2)), false)
end

def diagnostics
  rect_diagnostics

  diagnostic_inputs = ['#1 @ 1,3: 4x4',
                       '#2 @ 3,1: 4x4',
                       '#3 @ 5,5: 2x2']

  c1 = Claim.new(diagnostic_inputs[0])
  c2 = Claim.new(diagnostic_inputs[1])
  c3 = Claim.new(diagnostic_inputs[2])

  assert_equals(c1.intersects?(c2), true)
  assert_equals(c2.intersects?(c1), true)
  assert_equals(c1.intersects?(c3), false)
  assert_equals(c2.intersects?(c3), false)

  cc = ClaimsCompare.new([c1, c2, c3])
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

def execute
  claims = File.readlines("input.txt")[0..10].map { |ln| Claim.new(ln) }
  cc = ClaimsCompare.new(claims)
  p cc.overlapping_sq_inches
  p cc.non_overlapping_claims.map(&:id)
end

execute