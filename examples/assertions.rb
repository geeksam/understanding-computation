def assert(predicate)
  return if predicate
  raise "nope"
end

def refute(predicate)
  return unless predicate
  raise "nope"
end

def assert_equal(expected, actual)
  return if expected == actual
  raise <<-EOF

Expected #{expected.inspect}
to ==    #{actual.inspect}
  EOF
end

def example(description)
  yield
end
