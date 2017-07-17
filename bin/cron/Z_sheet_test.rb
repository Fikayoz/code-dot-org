#- Process Notes:
#1) Have a useable class
#2) Create a simple logic loop file
#3) API-key: e0e2bee07b6ffe86a7d44552636534b2
#4) Project ID: hour-of-code

require_relative '../../deployment'
require 'cdo/languages'
require 'find'

require 'crowdin-api'
require 'logger'
require 'httparty'

require 'open-uri'
require 'rubygems'
require 'zip'

crowdin = Crowdin::API.new(api_key: "e0e2bee07b6ffe86a7d44552636534b2", project_id: "hour-of-code")
crowdin.log = Logger.new $stderr

class PostTester
  include HTTParty
  base_uri "https://api.crowdin.com/"

  def trans_status
    self.class.get("/api/project/hour-of-code/status?key=e0e2bee07b6ffe86a7d44552636534b2")
  end

  def download_local
    self.class.get("/api/project/hour-of-code/download/ar.zip?key=e0e2bee07b6ffe86a7d44552636534b2")
  end
end

def file_collect
  other_files = Dir['../../lib/cdo/*.rb']
  puts other_files
end

#poster = PostTester.new
#puts poster.trans_status

input = HTTParty.get("https://api.crowdin.com/api/project/hour-of-code/download/ar.zip?key=e0e2bee07b6ffe86a7d44552636534b2").body
Zip::InputStream.open(StringIO.new(input)) do |io|
  while entry = io.get_next_entry
    puts entry.name
  end
end
