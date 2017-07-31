#1) Origin path: '../../i18n/locales/source'

require_relative '../../deployment'
require 'cdo/languages'
require 'find'

require 'httparty'

require 'open-uri'
require 'rubygems'
require 'zip'
require 'yaml'
require 'json'

class TranslateCheck

  def initialize
    @transFiles = Array.new()
    @sourceFiles = Array.new()
    @symbols = self.get_local_symbols
    @transScript = YAML.load_file(File.open("../../i18n/locales/ar-SA/dashboard/scripts.yml"))
    @scriptsSource = YAML.load_file(File.open("../../i18n/locales/source/dashboard/scripts.yml"))
    @studioSource = JSON.parse(File.read("../../i18n/locales/source/blockly-mooc/studio.json"))
    @mobileSource = YAML.load_file(File.open("../../i18n/locales/source/pegasus/mobile.yml"))
    @slideSource = YAML.load_file(File.open("../../i18n/locales/source/dashboard/slides.yml"))
    @scriptsFiles = self.get_scripts_files
    @studioFiles = self.get_studio_files
    @mobileFiles = self.get_mobile_files
    @slideFiles = self.get_slide_files
  end

  def get_local_symbols
    symbols = Array.new()
    Languages.get_locale.each do |properties|
      symbols[symbols.length] = properties[properties.keys[0]]
    end
    return symbols
  end

  def get_scripts_files
    scriptFiles = Array.new()
    @symbols.each do |symbol|
      file = File.open("../../i18n/locales/#{symbol}/dashboard/scripts.yml")
      scriptFiles[scriptFiles.length] = YAML.load_file(file)
    end
    return scriptFiles
  end

  def get_studio_files
    studioFiles = Array.new()
    @symbols.each do |symbol|
      file = File.read("../../i18n/locales/#{symbol}/blockly-mooc/studio.json")
      #text = File.read(file)
      studioFiles[studioFiles.length] = JSON.parse(file)
    end
    return studioFiles
  end

  def get_mobile_files
    mobileFiles = Array.new()
    @symbols.each do |symbol|
      file = File.open("../../i18n/locales/#{symbol}/pegasus/mobile.yml")
      mobileFiles[mobileFiles.length] = YAML.load_file(file)
    end
    return mobileFiles
  end

  def get_slide_files
    slideFiles = Array.new()
    @symbols.each do |symbol|
      file = File.open("../../i18n/locales/#{symbol}/dashboard/slides.yml")
      slideFiles[slideFiles.length] = YAML.load_file(file)
    end
    return slideFiles
  end

  def find_nested_key(obj,key)
    if obj.respond_to?(:key?) && obj.key?(key)
      return obj[key]
    elsif obj.respond_to?(:each)
      r = nil
      obj.find{ |*a| r=find_nested_key(a.last,key) }
      r
    end
  end

  def get_hash_list(courseName)
    starwarsSource = self.find_nested_key(@sourceScript,courseName)
    starwarsTrans = self.find_nested_key(@transScript,courseName)
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

  def trans_files(filesArray, phrase)
    filesArray.each do |script|
      puts "#{script.keys[0]}:"
      puts self.find_nested_key(script, phrase)
      puts "///////////////////////////////////////////////////////////////////////////"
      puts
    end
  end

  def scripts_files
    trans_files(@scriptsFiles, "starwarsblocks")
  end

  def mobile_files
    trans_files(@scriptsFiles, "starwars")
  end

  def slide_files
    trans_files(@scriptsFiles, "starwars")
  end

  #def trans_scripts
  #  trans_files(@scriptsFiles, "starwars")
  #end

end

test = TranslateCheck.new
#test.get_files
#puts
#test.read_file
#puts
#test.compare_lines
#test.get_hash_list("course2")
#test.trans_files
