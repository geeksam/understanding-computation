require 'pathname'
require 'fileutils'

@page_dir = Pathname.new(File.expand_path(File.dirname(__FILE__))).join('pages')

def page(page_number)
  page_file = 'page-%03d' % page_number
  ensure_page_file_exists page_file
  require @page_dir.join(page_file)
  yield if block_given?
end

def ensure_page_file_exists(page_file)
  page_file_rb = @page_dir.join(page_file + '.rb')
  return if File.exists?(page_file_rb)
  FileUtils.cp @page_dir.join('template'), page_file_rb
end
