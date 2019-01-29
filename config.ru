require './lib/racker'
use Rack::Reloader
use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => 'secret'
use Rack::Static, :urls => ["/assets"]

run Racker
