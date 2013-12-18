# try running this with:  irb -r ./examples.rb

require_relative 'simple'

@expr = Add.new(
  Multiply.new(Number.new(1), Number.new(2)),
  Multiply.new(Number.new(3), Number.new(4))
)

