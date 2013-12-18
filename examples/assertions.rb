def assert(predicate)
  return if predicate
  raise "nope"
end

def refute(predicate)
  return unless predicate
  raise "nope"
end

def assert_equal(a, b)
  return if a == b
  raise <<-EOF

Expected #{a.inspect}
to ==    #{b.inspect}
  EOF
end

def example(description)
  yield
end
