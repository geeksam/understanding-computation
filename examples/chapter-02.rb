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

require 'stringio'
def capture_output
  output = ""
  return output, StringIO.new(output)
end

page 28 do
  expr = Add.new(
    Multiply.new(Number.new(1), Number.new(2)),
    Multiply.new(Number.new(3), Number.new(4))
  )
  m = Machine.new(expr)

  output, m.io = capture_output
  m.run

  assert_equal output, <<-EOF
1 * 2 + 3 * 4
2 + 3 * 4
2 + 12
14
  EOF
end
