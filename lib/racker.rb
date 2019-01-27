require 'haml'
class Racker
  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def response
    case @request.path
    when '/' then Rack::Response.new(render('menu'))
    # when '/start' then Rack::Response.new(render('menu0.html.erb'))
    end
  end

  def render(template)
    path = File.expand_path("../../#{template}.haml", __FILE__)
    Haml::Engine.new(File.read(path)).render(binding)
  end
end
