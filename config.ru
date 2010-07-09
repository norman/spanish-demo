require File.expand_path("../spanish", __FILE__)
set :run, false
set :environment, :production
run Sinatra::Application
