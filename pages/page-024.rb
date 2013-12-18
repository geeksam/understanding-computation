# encoding: utf-8

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
