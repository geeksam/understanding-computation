require 'stringio'

module IO_Attr
  def io
    @io ||= STDOUT
  end

  def io=(new_io)
    @io = new_io
  end

  def puts(*args)
    io.puts(*args)
  end
end

def capture_output_on(object)
  object.extend(IO_Attr) unless object.kind_of?(IO_Attr)  # punch that duck
  s = ""
  s.encode! "UTF-8" # so it can handle those weird quote marks Tom loves so much
  object.io = StringIO.new(s)
  yield s
end
