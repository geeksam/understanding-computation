module IO_Attr
  def io
    @io ||= STDOUT
  end

  def io=(new_io)
    @io = new_io
  end
end
