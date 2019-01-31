class Racker
  ZERO_ATTEMPTS = 0.freeze

  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def response
    case @request.path
    when '/game', '/lose', '/', '/win' then check_game_state
    when '/check_number' then check_number
    when '/start' then start
    when '/rules' then show_page('rules')
    when '/stats' then show_page('statistics')
    when '/show_hint' then hint
    else show_page('error404')
    end
  end

  def data_base
    console = Codebreaker::Console.new
    base = console.load_db
    Codebreaker::Statistics.new.winners(base)
  end

  def check_game_state
    return show_page('menu') unless current_game
    return show_page('game') if game_go_on?
    return show_page('win') if current_game.winner
    return show_page('lose') if current_game.attempts_left == ZERO_ATTEMPTS
  end

  def game_go_on?
    !current_game.winner && current_game.attempts_left > ZERO_ATTEMPTS
  end

  def check_number
    return show_page('menu') unless current_game
    return show_page('game') unless @request.params['number']

    @request.session[:number] = @request.params['number']
    @request.session[:markers] = current_game.attempt(@request.params['number'])
    redirect_to('/')
  end

  def hint
    return show_page('menu') unless current_game

    @request.session[:hints] += current_game.attempt(Codebreaker::Game::GUESS_CODE[:hint]) if current_game.have_hints > 0
    redirect_to('game')
  end

  def show_hints
    @request.session[:hints].chars
  end

  def clear_session
    @request.session.clear
  end

  def markers_answer
    return ['', '', '', ''] unless @request.session[:markers]
    marks = @request.session[:markers].chars
    Codebreaker::Game::AMOUNT_DIGITS.times { marks.push('') }
    marks.first(Codebreaker::Game::AMOUNT_DIGITS)
  end

  def start
    return show_page('menu') unless @request.params['player_name']

    @request.session[:hints] = ''
    @request.session[:name] = @request.params['player_name']
    @request.session[:level] = @request.params['level']
    current_player = Codebreaker::Player.new
    current_player.assign_name(@request.params['player_name'].capitalize)
    game = Codebreaker::Game.new
    game.game_options(user_difficulty: @request.params['level'], player: current_player)
    @request.session[:game] = game
    redirect_to('game')
  end

  def redirect_to(url)
    Rack::Response.new { |response| response.redirect(url) }
  end

  def current_game
    @request.session[:game]
  end

  def show_page(page)
    Rack::Response.new(render(page))
  end

  def level
    @request.session[:level]
  end

  def current_guess
    @request.session[:number]
  end

  def player_name
    @request.session[:name]
  end

  def render(template)
    layout_path = File.expand_path("../../lib/views/layout.haml", __FILE__)
    Haml::Engine.new(File.read(layout_path)).render do
      path = File.expand_path("../../lib/views/#{template}.haml", __FILE__)
      Haml::Engine.new(File.read(path)).render(binding)
    end
  end
end
