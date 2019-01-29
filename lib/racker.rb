require 'haml'
require 'codebreaker'

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
    when '/lose' then Rack::Response.new(render('lose'))
    when '/stats' then Rack::Response.new(render('statistics'))
    when '/win' then Rack::Response.new(render('win'))
    when '/game' then game
    when '/start' then start
    when '/show_hint' then hint
    end
  end

  def game
    return show_page('menu') unless current_game
    @request.session[:bug] =  @request.params['number']
    @request.session[:merkers] = current_game.attempt(@request.params['number'])
    return show_page('win') if current_game.winner
    return show_page('lose') unless current_game.attempts_left > 0

    show_page('game')
  end

  def debug
    @request.session[:bug]
  end

  def hint
    @request.session[:hints] += current_game.attempt(Codebreaker::Game::GUESS_CODE[:hint]) if current_game.have_hints > 0
    show_page('game')
  end

  def show_hints
    @request.session[:hints].chars
  end

  def clear_session
    @request.session.clear
  end

  def markers_answer
    return ['', '', '', ''] unless @request.session[:merkers]
    marks = @request.session[:merkers].chars
    Codebreaker::Game::RANGE_OF_DIGITS.last.times { marks.push('') }
    marks.first(Codebreaker::Game::RANGE_OF_DIGITS.last)
  end

  def start
    clear_session
    @request.session[:hints] = ''
    @request.session[:level] = @request.params['level']
    current_player = Codebreaker::Player.new
    current_player.assign_name(@request.params['player_name'].capitalize)
    current_game = Codebreaker::Game.new
    current_game.game_options(user_difficulty: @request.params['level'], player: current_player)
    @request.session[:game] = current_game
    show_page('game')
  end

  def current_game
    @request.session[:game]
  end

  def show_page(page_name)
    Rack::Response.new(render(page_name))
  end

  def level
    @request.session[:level]
  end

  def current_guess
    @request.params['number']
  end

  def player_name
    @request.params['player_name']
  end

  def render(template)
    path = File.expand_path("../../lib/views/#{template}.haml", __FILE__)
    Haml::Engine.new(File.read(path)).render(binding)
  end
end
