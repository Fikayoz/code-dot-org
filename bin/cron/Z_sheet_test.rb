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
    @scriptSource = YAML.load_file(File.open("../../i18n/locales/source/dashboard/scripts.yml"))
    @studioSource = YAML.load_file(File.open("../../i18n/locales/source/dashboard/scripts.yml"))
    @mobileSource = YAML.load_file(File.open("../../i18n/locales/source/dashboard/scripts.yml"))
    @slideSource = YAML.load_file(File.open("../../i18n/locales/source/dashboard/scripts.yml"))
    @symbols = self.get_local_symbols
    @scriptFiles = self.get_local_scripts
    @studioFiles = Array.new()
    @mobileFiles = Array.new()
    @slideFiles = Array.new()
  end

  def get_local_symbols
    symbols = Array.new()
    Languages.get_locale.each do |properties|
      symbols[symbols.length] = properties[properties.keys[0]]
    end
    return symbols
  end

  def get_local_scripts
    scriptFiles = Array.new()
    @symbols.each do |symbol|
      file = File.open("../../i18n/locales/#{symbol}/dashboard/scripts.yml")
      scriptFiles[scriptFiles.length] = YAML.load_file(file)
    end
    return scriptFiles
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

  def get_hash_list(courseName)
    starwarsSource = self.nested_hash_value(@sourceScript,courseName)
    starwarsTrans = self.nested_hash_value(@transScript,courseName)
    @holder = Hash.new(0)
    hash_search(starwarsSource)
    source = @holder 
    @holder = Hash.new(0)
    hash_search(starwarsTrans)
    trans = @holder
    source.each do |key, value|
      puts source[key]
      puts trans[key]
      translated = source[key] != trans[key]
      if source[key].strip.empty? && trans[key].strip.empty?
        translated = true
      end
      puts translated
      puts "//////////////////////////////"
      puts
    end
  end

  def hash_search(hash)
    hash.each do |key, value|
      if value.is_a?(Hash)
        hash_search(value)
      else
        #puts "Key: #{key}, value: #{value}"
        @holder[key] = value
      end
    end
  end

  def compare
  end

  def g_sheet_communicate
    #puts @symbols
    @transScripts.each do |script|
      puts "#{script.keys[0]}:"
      puts self.nested_hash_value(script, "starwars")
      puts "/////////////////////////////////////////////////"
      puts
    end
  end

end

test = TranslateCheck.new
#test.get_files
#puts
#test.read_file
#puts
#test.compare_lines
#test.get_hash_list("course2")
test.g_sheet_communicate
