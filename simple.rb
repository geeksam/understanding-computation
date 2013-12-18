# encoding: utf-8

### Page 23
class Number < Struct.new(:value)
end

class Add < Struct.new(:left, :right)
end

class Multiply < Struct.new(:left, :right)
end


### Page 24
class Number
  def to_s
    value.to_s
  end

  def inspect
    "«#{self}»"
  end
end

class Add
  def to_s
    "#{left} + #{right}"
  end

  def inspect
    "«#{self}»"
  end
end

class Multiply
  def to_s
    "#{left} * #{right}"
  end

  def inspect
    "«#{self}»"
  end
end
