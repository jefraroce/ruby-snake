require "ruby2d"
require_relative '../model/state'

module View
  class Ruby2d

    def initialize(app)
      @pixel_size = 40
      @app = app
      @previous_score = nil
    end

    def start(state)
      extend Ruby2D::DSL
      width = @pixel_size * state.grid.cols
      height = @pixel_size * state.grid.rows

      set(
        title: 'Snake',
        width: width,
        height: height + 100
      )

      # Bottom limit
      Line.new(
        x1: 0, y1: height + 1,
        x2: width, y2: height + 1,
        width: 5,
        color: 'gray',
        z: 20
      )

      on :key_down do |event|
        handle_key_event(event, state)
      end

      show
    end

    def render(state)
      render_game_over if state.game_finished
      render_food(state)
      render_snake(state)
      if @previous_score != state.score
        render_score(state)
        @previous_score = state.score
      end
    end

    private

    def render_food(state)
      @food.remove if defined?(@food)
      extend Ruby2D::DSL
      food = state.food
      @food = Square.new(
        x: food.col * @pixel_size,
        y: food.row * @pixel_size,
        size: @pixel_size,
        color: 'yellow'
      )
    end

    def render_snake(state)
      @snake_positions.each(&:remove) if defined?(@snake_positions)
      extend Ruby2D::DSL
      snake = state.snake
      @snake_positions = snake.positions.map do |position|
        Square.new(
          x: position.col * @pixel_size,
          y: position.row * @pixel_size,
          size: @pixel_size,
          color: 'green'
        )
      end
    end

    def render_score(state)
      @score.remove if defined?(@score)
      extend Ruby2D::DSL

      @score = Text.new(
        "SCORE: #{state.score}",
        x: 100,
        y: @pixel_size * state.grid.rows + 10,
        font: File.expand_path('../../assets/fonts/VT323-Regular.ttf', __FILE__),
        size: 50,
        color: 'white'
      )
    rescue StandardError => e
      puts "ERROR: #{e.inspect}"
    end

    def render_game_over
      extend Ruby2D::DSL

      Text.new(
        'GAME OVER',
        x: Window.width / 2 - 60,
        y: Window.height - 40,
        font: File.expand_path('../../assets/fonts/VT323-Regular.ttf', __FILE__),
        size: 30,
        color: 'red'
      )
    rescue StandardError => e
      puts "ERROR: #{e.inspect}"
    end

    def handle_key_event(event, state)
      case event.key
      when 'up'
        @app.send_action(:change_direction, Model::Direction::UP)
      when 'down'
        @app.send_action(:change_direction, Model::Direction::DOWN)
      when 'left'
        @app.send_action(:change_direction, Model::Direction::LEFT)
      when 'right'
        @app.send_action(:change_direction, Model::Direction::RIGHT)
      end
    end
  end
end