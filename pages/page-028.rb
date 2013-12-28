class Machine < Struct.new(:expression)
  def step
    self.expression = expression.reduce
  end

  def run
    while expression.reducible?
      puts expression
      step
    end
    puts expression
  end
end


# My own additions for testing...
class Machine
  include IO_Attr

  def run
    while expression.reducible?
      io.puts expression
      step
    end
    io.puts expression
  end
end
