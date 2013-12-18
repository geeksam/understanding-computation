require 'pathname'
@page_dir = Pathname.new(File.expand_path(File.dirname(__FILE__))).join('pages')

def page(page_number)
  page_file = 'page-%03d' % page_number
  require @page_dir.join(page_file)
  yield if block_given?
end
