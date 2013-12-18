# encoding: utf-8

require 'pathname'
@page_dir = Pathname.new(File.dirname(__FILE__))

def page(page_number)
  page_file = 'page-%03d' % page_number
  require @page_dir.join('pages', page_file)
end

page 23
page 24
page 26
page 27


