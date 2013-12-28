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

