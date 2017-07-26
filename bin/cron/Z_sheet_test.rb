#1) Origin path: '../../i18n/locales/source'

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
    @transScript = YAML.load_file(File.open("../../i18n/locales/ar-SA/dashboard/scripts.yml"))
    @sourceScript = YAML.load_file(File.open("../../i18n/locales/source/dashboard/scripts.yml"))
    self.get_local_symbols
    self.get_local_scripts
  end

  def get_local_symbols
    @symbols = Array.new()
    Languages.get_locale.each do |properties|
      @symbols[@symbols.length] = properties[properties.keys[0]]
    end
  end

  def get_local_scripts
    @transScripts = Array.new()
    @symbols.each do |symbol|
      file = File.open("../../i18n/locales/#{symbol}/dashboard/scripts.yml")
      @transScripts[@transScripts.length] = YAML.load_file(file)
    end
  end

  def parse_yaml
    base = File.open("../../i18n/locales/source/dashboard/scripts.yml")
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
    starwarsSource = self.nested_hash_value(@sourceScript,"starwars")
    starwarsTrans = self.nested_hash_value(@transScript,"starwars")
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

  def g_sheet_communicate #////////////////////////////////////////
    puts @symbols
  end

end

test = TranslateCheck.new
#test.get_files
#puts
#test.read_file
#puts
#test.compare_lines
#test.get_hash_list
test.g_sheet_communicate
#puts test.nested_hash_value(YAML.load_file(File.open('../../i18n/locales/source/dashboard/scripts.yml')),"starwars")
