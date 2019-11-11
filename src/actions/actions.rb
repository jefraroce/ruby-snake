module Actions
  def self.move_snake(state)
    current_direction = state.current_direction
    next_position = calc_next_position(state)
    # Checks if the next cell is a piece of food or valid
    if next_position_is_food?(state, next_position)
      state = grow_snake(state, next_position)
      state = generate_food(state)
      state = increase_score(state)
    elsif next_position_is_valid?(state, next_position)
      state = move_snake_to(state, next_position)
    else
      state = end_game(state)
    end

    state
  end

  def self.change_direction(state, next_direction)
    if direction_is_valid?(state.current_direction, next_direction) && direction_is_valid?(state.snake.last_head_direction, next_direction)
      state.current_direction = next_direction
    else
      puts "Invalid direction"
    end

    state
  end

  private

  class << self
    def calc_next_position(state)
      current_position = state.snake.positions.first

      case state.current_direction
      when Model::Direction::UP
        return Model::Coord.new(
          current_position.row - 1,
          current_position.col
        )
      when Model::Direction::RIGHT
        return Model::Coord.new(
          current_position.row,
          current_position.col + 1
        )
      when Model::Direction::DOWN
        return Model::Coord.new(
          current_position.row + 1,
          current_position.col
        )
      when Model::Direction::LEFT
        return Model::Coord.new(
          current_position.row,
          current_position.col - 1
        )
      end
    end

    def direction_is_valid?(current_direction, next_direction)
      case current_direction
      when Model::Direction::UP
        return false if next_direction == Model::Direction::DOWN
      when Model::Direction::RIGHT
        return false if next_direction == Model::Direction::LEFT
      when Model::Direction::DOWN
        return false if next_direction == Model::Direction::UP
      when Model::Direction::LEFT
        return false if next_direction == Model::Direction::RIGHT
      end

      true
    end

    def generate_food(state)
      food_position = Model::Coord.new(rand(state.grid.rows), rand(state.grid.cols))
      loop do
        break unless state.snake.positions.include? food_position
        food_position = Model::Coord.new(rand(state.grid.rows), rand(state.grid.cols))
      end
      state.food = Model::Food.new(food_position.row, food_position.col)
      state
    end

    def grow_snake(state, next_position)
      state = update_last_head_direction(state)
      new_positions = [next_position] + state.snake.positions
      state.snake.positions = new_positions
      state
    end

    def increase_score(state)
      state.score = state.score.to_i + 100
      state
    end

    def next_position_is_food?(state, next_position)
      state.food.col == next_position.col && state.food.row == next_position.row
    end

    def next_position_is_valid?(state, next_position)
      is_valid = true

      # Checks that position is inside of grid
      is_valid = false if next_position.row < 0 || next_position.row >= state.grid.rows || next_position.col < 0 || next_position.col >= state.grid.cols

      # Checks that position is not occupied by the snake body
      is_valid = false if state.snake.positions.include? next_position

      is_valid
    end

    def move_snake_to(state, next_position)
      state = update_last_head_direction(state)
      new_positions = [next_position] + state.snake.positions[0...-1]
      state.snake.positions = new_positions
      state
    end

    def end_game(state)
      state.game_finished = true
      state
    end

    def update_last_head_direction(state)
      state.snake.last_head_direction = state.current_direction
      state
    end
  end
end