# encoding: utf-8
#
require File.expand_path( File.join(File.dirname(__FILE__), *%w[ .. pages ]) )

page 23

page 24 do
  example "#inspect" do
    expr = Add.new(
      Multiply.new(Number.new(1), Number.new(2)),
      Multiply.new(Number.new(3), Number.new(4))
    )
    assert_equal '«1 * 2 + 3 * 4»', expr.inspect
  end
end

page 26 do
  example "#reducible?" do
    refute Number.new(1).reducible?
    assert Add.new(Number.new(1), Number.new(2)).reducible?
  end
end

page 27 do
  ex = Add.new(
    Multiply.new(Number.new(1), Number.new(2)),
    Multiply.new(Number.new(3), Number.new(4))
  )
  assert_equal('«1 * 2 + 3 * 4»', ex.inspect)

  assert ex.reducible?
  ex = ex.reduce
  assert_equal('«2 + 3 * 4»', ex.inspect)

  assert ex.reducible?
  ex = ex.reduce
  assert_equal('«2 + 12»', ex.inspect)

  assert ex.reducible?
  ex = ex.reduce
  assert_equal('«14»', ex.inspect)
end

page 28 do
  expr = Add.new(
    Multiply.new(Number.new(1), Number.new(2)),
    Multiply.new(Number.new(3), Number.new(4))
  )
  m = Machine.new(expr)

  capture_output_on(m) do |output|
    m.run

    assert_equal output, <<-EOF
1 * 2 + 3 * 4
2 + 3 * 4
2 + 12
14
    EOF
  end
end

page 29 do
  m = Machine.new(
    LessThan.new( Number.new(5), Add.new( Number.new(2), Number.new(2) ) )
  )

  capture_output_on(m) do |output|
    m.run

    assert_equal output, <<-EOF
5 < 2 + 2
5 < 4
false
    EOF
  end
end

page 30 do
  v = Variable.new(:x)
  assert v.reducible?
  assert_equal "«x»", v.inspect
end

page 31 do
  m = Machine.new(
    Add.new( Variable.new(:x), Variable.new(:y) ),
    { x: Number.new(3), y: Number.new(4) }
  )

  capture_output_on(m) do |output|
    m.run

    assert_equal output, <<-EOF
x + y
3 + y
3 + 4
7
    EOF
  end
end

page 33 do
  a = DoNothing.new
  b = DoNothing.new
  assert_equal a, b
  refute a.reducible?
end

page 35 do
  statement = Assign.new( :x, Add.new(Variable.new(:x), Number.new(1)) )
  assert_equal "«x = x + 1»", statement.inspect
  assert statement.reducible?
  environment = { x: Number.new(2) }

  statement, environment = statement.reduce(environment)
  assert_equal "«x = 2 + 1»", statement.inspect
  assert_equal( { x: Number.new(2) }, environment )

  statement, environment = statement.reduce(environment)
  assert_equal "«x = 3»", statement.inspect
  assert_equal( { x: Number.new(2) }, environment )

  statement, environment = statement.reduce(environment)
  assert_equal "«do-nothing»", statement.inspect
  assert_equal( { x: Number.new(3) }, environment )
end

page 36 do
  m = Machine.new(
    Assign.new( :x, Add.new( Variable.new(:x), Number.new(1) ) ),
    { x: Number.new(2) }
  )

  capture_output_on(m) do |output|
    m.run

    assert_equal output, <<-EOF
x = x + 1, {:x=>«2»}
x = 2 + 1, {:x=>«2»}
x = 3, {:x=>«2»}
do-nothing, {:x=>«3»}
    EOF
  end
end

page 37 do
  m = Machine.new(
    If.new(
      Variable.new(:x),
      Assign.new(:y, Number.new(1)),
      Assign.new(:y, Number.new(2))
    ),
    { x: Boolean.new(true) }
  )

  capture_output_on(m) do |output|
    m.run

    assert_equal output, <<-EOF
if (x) { y = 1 } else { y = 2 }, {:x=>«true»}
if (true) { y = 1 } else { y = 2 }, {:x=>«true»}
y = 1, {:x=>«true»}
do-nothing, {:x=>«true», :y=>«1»}
    EOF
  end
end

page 37 do
  m = Machine.new(
    If.new(
      Variable.new(:x),
      Assign.new(:y, Number.new(1)),
      DoNothing.new
    ),
    { x: Boolean.new(true) }
  )

  capture_output_on(m) do |output|
    m.run

    assert_equal output, <<-EOF
if (x) { y = 1 } else { do-nothing }, {:x=>«true»}
if (true) { y = 1 } else { do-nothing }, {:x=>«true»}
y = 1, {:x=>«true»}
do-nothing, {:x=>«true», :y=>«1»}
    EOF
  end
end

page 38 do
  m = Machine.new(
    Sequence.new(
      Assign.new( :x, Add.new(Number.new(1), Number.new(1)) ),
      Assign.new( :y, Add.new(Variable.new(:x), Number.new(3)) )
    ),
    {}
  )

  capture_output_on(m) do |output|
    m.run

    assert_equal output, <<-EOF
x = 1 + 1; y = x + 3, {}
x = 2; y = x + 3, {}
do-nothing; y = x + 3, {:x=>«2»}
y = x + 3, {:x=>«2»}
y = 2 + 3, {:x=>«2»}
y = 5, {:x=>«2»}
do-nothing, {:x=>«2», :y=>«5»}
    EOF
  end
end

page 40 do
  m = Machine.new(
    While.new(
      LessThan.new( Variable.new(:x), Number.new(5) ),
      Assign.new( :x, Multiply.new(Variable.new(:x), Number.new(3)) )
    ),
    { x: Number.new(1) }
  )

  capture_output_on(m) do |output|
    m.run

    assert_equal output, <<-EOF
while (x < 5) { x = x * 3 }, {:x=>«1»}
if (x < 5) { x = x * 3; while (x < 5) { x = x * 3 } } else { do-nothing }, {:x=>«1»}
if (1 < 5) { x = x * 3; while (x < 5) { x = x * 3 } } else { do-nothing }, {:x=>«1»}
if (true) { x = x * 3; while (x < 5) { x = x * 3 } } else { do-nothing }, {:x=>«1»}
x = x * 3; while (x < 5) { x = x * 3 }, {:x=>«1»}
x = 1 * 3; while (x < 5) { x = x * 3 }, {:x=>«1»}
x = 3; while (x < 5) { x = x * 3 }, {:x=>«1»}
do-nothing; while (x < 5) { x = x * 3 }, {:x=>«3»}
while (x < 5) { x = x * 3 }, {:x=>«3»}
if (x < 5) { x = x * 3; while (x < 5) { x = x * 3 } } else { do-nothing }, {:x=>«3»}
if (3 < 5) { x = x * 3; while (x < 5) { x = x * 3 } } else { do-nothing }, {:x=>«3»}
if (true) { x = x * 3; while (x < 5) { x = x * 3 } } else { do-nothing }, {:x=>«3»}
x = x * 3; while (x < 5) { x = x * 3 }, {:x=>«3»}
x = 3 * 3; while (x < 5) { x = x * 3 }, {:x=>«3»}
x = 9; while (x < 5) { x = x * 3 }, {:x=>«3»}
do-nothing; while (x < 5) { x = x * 3 }, {:x=>«9»}
while (x < 5) { x = x * 3 }, {:x=>«9»}
if (x < 5) { x = x * 3; while (x < 5) { x = x * 3 } } else { do-nothing }, {:x=>«9»}
if (9 < 5) { x = x * 3; while (x < 5) { x = x * 3 } } else { do-nothing }, {:x=>«9»}
if (false) { x = x * 3; while (x < 5) { x = x * 3 } } else { do-nothing }, {:x=>«9»}
do-nothing, {:x=>«9»}
    EOF
  end
end
