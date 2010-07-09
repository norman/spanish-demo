# encoding: utf-8
$KCODE = "U" if RUBY_VERSION < "1.9"
require "rubygems"
require "bundler"
Bundler.setup
require "json"
require "haml"
require "sinatra"
require "spanish"

before do
  content_type 'text/html', :charset => 'utf-8'
  hash = params["rules"] || {}
  @rules = hash.keys.map {|name| name.to_sym if hash[name] == "1"}.compact
  if params["words"] && RUBY_VERSION >= "1.9"
    params["words"].force_encoding("UTF-8")
  end
end

helpers do
  def checkbox(label, options, &block)
    capture_haml do
      haml_tag :input, options.merge(:type => "checkbox", :checked => (block.call if block_given?))
      haml_tag :label, label, :for => options[:id]
      haml_tag :br
    end
  end
end

get("/") { haml :index }

get "/ipa" do
  @title = params["words"]
  @words = params["words"]
  @ipa = params["words"].split(/\s+/u).map do |word|
    trans = Spanish.get_syllables(word, *@rules)
    trans.map {|s| s.to_s }.join(" ")
  end.join(" &bull; ")
  haml :index
end
