require_relative './autoload.rb'

use Rack::Reloader
use Rack::Session::Cookie, key: 'rack.session',
                           secret: 'secret'
use Rack::Static, urls: ['/public', '/node_modules'], root: './'

run Racker
