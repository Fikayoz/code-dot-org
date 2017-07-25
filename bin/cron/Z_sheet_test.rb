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
    @transScript = YAML.load_file(File.open('../../i18n/locales/ar-SA/dashboard/scripts.yml'))
    @sourceScript = YAML.load_file(File.open('../../i18n/locales/source/dashboard/scripts.yml'))
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
    self.nested_hash_value(test,"starwars")
    puts
    #puts test[en][data][script][name][starwars]
    puts base.class
    puts test.class
  end

  def nested_hash_value(obj,key)
    if obj.respond_to?(:key?) && obj.key?(key)
      return obj[key]
    elsif obj.respond_to?(:each)
      r = nil
      obj.find{ |*a| r=nested_hash_value(a.last,key) }
      r
    end
  end

  def get_hash_list
    starwarsSource = self.nested_hash_value(@transScript,"starwars")
    starwarsTrans = self.nested_hash_value(@sourceScript,"starwars")
    hash_search(starwarsSource)
    puts
    hash_search(starwarsTrans)
  end

  def hash_search(hash)
    hash.each do |key, value|
      if value.is_a?(Hash)
        hash_search(value)
      else
        puts "Key: #{key}, value: #{value}"
      end
    end
  end

end

test = TranslateCheck.new
#test.get_files
#puts
#test.read_file
#puts
#test.compare_lines
test.get_hash_list
