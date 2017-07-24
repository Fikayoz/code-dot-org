#1) API-key: 0b35d4f4184c255ce002643252f0671e
#2) Project ID: codeorg
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
require 'yaml'

class TranslateCheck

  def initialize
    @transFiles = Array.new()
    @sourceFiles = Array.new()
    @transCode = "ar"
    @transOnline = HTTParty.get("https://api.crowdin.com/api/project/codeorg/download/ar.zip?key=0b35d4f4184c255ce002643252f0671e").body
    @transContent = ""
    @scripts = File.open('../../i18n/locales/source/dashboard/scripts.yml').read
  end

  def get_files
    Zip::InputStream.open(StringIO.new(@transOnline)) do |zip_file|
      while entry = zip_file.get_next_entry
        puts entry.name 
        if entry.name.end_with?("scripts.yml")
          @transFiles[@transFiles.length] = entry
        end
      end
    end
  end

  def read_file
    Zip::InputStream.open(StringIO.new(@transOnline)) do |zip_file|
      while file = zip_file.get_next_entry
        if file.name.end_with?("scripts.yml")
          puts file.class
          @transContent = file.get_input_stream.read
          #puts @transContent.class
          #puts
          #puts @transContent
        end
      end
    end
  end

  def compare_lines
    sourceLines = @scripts.split("\n")[2..-1]
    transLines = @transContent.split("\n")
    translated = Array.new()
    untranslated = Array.new()
    for i in 0..10#sourceLines.length
      puts sourceLines[i]
      puts transLines[i]
      if sourceLines[i] == transLines[i]
        #untranslated[untranslated.length] == transLines[i]
        puts ("//////////////////////////////////////// untranslated")
        puts
      else
        #translated[translated.length] == transLines[i]
        puts ("//////////////////////////////////////// translated")
        puts
      end
    end
    #puts translated
    #puts ("Testing, testing")
    #puts untranslated
  end

  def parse_yaml
    base = File.open('../../i18n/locales/source/dashboard/scripts.yml')
    test = YAML.load_file(base)
    #puts test[en][data][script][name][starwars]
    puts base.class
    puts test.class
  end

end

test = TranslateCheck.new
#test.get_files
#puts
#test.read_file
#puts
#test.compare_lines
test.parse_yaml
