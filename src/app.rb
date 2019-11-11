require_relative "view/ruby2d"
require_relative "model/state"
require_relative "actions/actions"

class App
  def initialize
    @state = Model.initial_state
    @prev_time_to_sleep = 0
  end

  def start
    @view = View::Ruby2d.new(self)
    timer_thread = Thread.new { init_timer(@view) }
    @view.start(@state)
    timer_thread.join
  end

  def init_timer(view)
    loop do
      if @state.game_finished
        puts "Juego finalizado"
        puts "Puntaje: #{@state.score}"
        break
      end
      @state = Actions.move_snake(@state)
      view.render(@state)
      time_to_sleep = (0.5 - @state.score.to_i * 0.0001)
      sleep time_to_sleep < 0.1 ? 0.1 : time_to_sleep
    end
  end

  def send_action(action, params)
    new_state = Actions.send(action, @state, params)
    if new_state.hash != @state.hash
      @state = new_state
      @view.render(@state)
    end
  end
end

app = App.new
app.start