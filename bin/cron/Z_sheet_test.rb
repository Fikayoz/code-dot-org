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
    @transFiles = Array.new()
    @sourceFiles = Array.new()
    @transCode = "ar"
    @transOnline = HTTParty.get("https://api.crowdin.com/api/project/hour-of-code/download/ar.zip?key=e0e2bee07b6ffe86a7d44552636534b2").body
    @sourceOnline = HTTParty.get("https://api.crowdin.com/api/project/hour-of-code/download/en.zip?key=e0e2bee07b6ffe86a7d44552636534b2").body
    @transContent = ""
    @sourceContent = ""
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
    Zip::InputStream.open(StringIO.new(@transOnline)) do |zip_file|
      while entry = zip_file.get_next_entry
        puts entry.name 
        if entry.name.end_with?(".md")
          @transFiles[@transFiles.length] = entry
        end
      end
    end
    Zip::InputStream.open(StringIO.new(@sourceOnline)) do |zip_file|
      while entry = zip_file.get_next_entry
        puts entry.name 
        if entry.name.end_with?(".md")
          @sourceFiles[@sourceFiles.length] = entry
        end
      end
    end
  end

  def check_files
    @transFiles.each do |file|
      puts file.name
    end
  end

  def read_file
    Zip::InputStream.open(StringIO.new(@transOnline)) do |zip_file|
      while file = zip_file.get_next_entry
        if file.name == @transFiles[0].name
          puts file.class
          @transContent = file.get_input_stream.read
          puts @transContent.class
          #puts
          #puts @transContent
        end
      end
    end
    Zip::InputStream.open(StringIO.new(@sourceOnline)) do |zip_file|
      while file = zip_file.get_next_entry
        if file.name == @sourceFiles[0].name
          puts file.class
          @sourceContent = file.get_input_stream.read
          puts @sourceFiles.class
          #puts @sourceFiles
        end
      end
    end
  end

  def parse_n_compare
    #transLines = []
    #sourceLines = []
    #@sourceContent = @sourceContent.strip
    #@sourceContent.gsub /^$\n/, ''
    #@transContent = @transContent.strip
    #@transeContent.gsub /^$\n/, ''    
    puts @transContent
    puts
    puts "/////////////////////////////////////////////////////////////////////////////////////////////////////////////////"
    puts
    puts @sourceContent
    puts @sourceContent == @transContent
  end

end

test = TranslateCheck.new
test.get_files
puts
test.read_file
puts
test.parse_n_compare
#test.check_files
