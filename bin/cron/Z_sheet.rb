#1) API-key: e0e2bee07b6ffe86a7d44552636534b2
#2) Project ID: hour-of-cod
#3) low compare: co
#4) high compare: pt-BR
#5) Origin path: '../../i18n/locales/source'

require_relative '../../deployment'
require 'cdo/languages'
require 'find'

require 'httparty'

require 'open-uri'
require 'rubygems'
require 'zip'

class TranslateCheck

  def initialize
    @files = Array.new()
    @source = Array.new()
    @transCode = "ar"
  end

  def download_english
    open('Source.zip', 'wb') do |file|
      file << open('https://api.crowdin.com/api/project/hour-of-code/download/en.zip?key=e0e2bee07b6ffe86a7d44552636534b2').read
    end
  end

  def download_trans
    open(@transCode + '.zip', 'wb') do |file|
      file << open('https://api.crowdin.com/api/project/hour-of-code/download/' + @transCode + '.zip?key=e0e2bee07b6ffe86a7d44552636534b2').read
    end
  end

  def get_files
    input = File.open(@transCode + ".zip")
    Zip::InputStream.open(@transCode + ".zip") do |zip_file|
      while entry = zip_file.get_next_entry
        puts entry.name 
        if entry.name.end_with?(".md")
          @files[@files.length] = entry
        end
      end
    end
  end

  def check_files
    @files.each do |file|
      puts file.name
    end
  end

  def read_file
    puts @files[0].file?
    Zip::File.open(@files[0]) do |zip_file|
      zip_file.each do |entry|
        puts entry.inspect
        if entry.directory?
          puts "#{entry.name} is a folder!"
        elsif entry.symlink?
          puts "#{entry.name} is a symlink!"
        elsif entry.file?
          puts "#{entry.name} is a regular file!"

          # Read into memory
          content = entry.get_input_stream.read

          # Output
          puts content
        else
          puts "No sell"
        end
      end
    end
  end

end

test = TranslateCheck.new
test.get_files
test.read_file
#test.check_files
