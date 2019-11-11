require 'minitest/autorun'
require 'minitest/mock'
require_relative '../src/model/state'
require_relative '../src/actions/actions'

class ActionTest < Minitest::Test
  def setup
    @initial_state = Model::State.new(
      Model::Snake.new([
        Model::Coord.new(1, 1),
        Model::Coord.new(0, 1)
      ]),
      Model::Food.new(4, 4),
      Model::Grid.new(8, 12),
      Model::Direction::DOWN,
      false,
      0
    )
  end

  def test_move_snake
    expected_state = Model::State.new(
      Model::Snake.new([
        Model::Coord.new(2, 1),
        Model::Coord.new(1, 1)
      ]),
      Model::Food.new(4, 4),
      Model::Grid.new(8, 12),
      Model::Direction::DOWN,
      false,
      0
    )

    actual_state = Actions.move_snake(@initial_state)
    assert_equal actual_state, expected_state
  end

  def test_direction_change
    expected_state = Model::State.new(
      Model::Snake.new([
        Model::Coord.new(1, 1),
        Model::Coord.new(0, 1)
      ]),
      Model::Food.new(4, 4),
      Model::Grid.new(8, 12),
      Model::Direction::RIGHT,
      false,
      0
    )

    actual_state = Actions.change_direction(@initial_state, Model::Direction::RIGHT)
    assert_equal actual_state, expected_state
  end

  def test_direction_change_invalid
    expected_state = Model::State.new(
      Model::Snake.new([
        Model::Coord.new(1, 1),
        Model::Coord.new(0, 1)
      ]),
      Model::Food.new(4, 4),
      Model::Grid.new(8, 12),
      Model::Direction::DOWN,
      false,
      0
    )

    actual_state = Actions.change_direction(@initial_state, Model::Direction::UP)
    assert_equal actual_state, expected_state
  end

  def test_grow_snake
    initial_state = Model::State.new(
      Model::Snake.new([
        Model::Coord.new(1, 1),
        Model::Coord.new(0, 1)
      ]),
      Model::Food.new(2, 1),
      Model::Grid.new(8, 12),
      Model::Direction::DOWN,
      false,
      0
    )

    actual_state = Actions.move_snake(initial_state)
    assert_equal actual_state.snake.positions, [
      Model::Coord.new(2, 1),
      Model::Coord.new(1, 1),
      Model::Coord.new(0, 1)
    ]
  end

  def test_increase_score
    initial_state = Model::State.new(
      Model::Snake.new([
        Model::Coord.new(1, 1),
        Model::Coord.new(0, 1)
      ]),
      Model::Food.new(2, 1),
      Model::Grid.new(8, 12),
      Model::Direction::DOWN,
      false,
      0
    )

    actual_state = Actions.move_snake(initial_state)
    assert_equal actual_state.score.to_i, 100
  end

  def test_generate_food
    initial_state = Model::State.new(
      Model::Snake.new([
        Model::Coord.new(1, 1),
        Model::Coord.new(0, 1)
      ]),
      Model::Food.new(2, 1),
      Model::Grid.new(8, 12),
      Model::Direction::DOWN,
      false,
      0
    )

    expected_state = Model::State.new(
      Model::Snake.new([
        Model::Coord.new(2, 1),
        Model::Coord.new(1, 1),
        Model::Coord.new(0, 1)
      ]),
      Model::Food.new(0, 0),
      Model::Grid.new(8, 12),
      Model::Direction::DOWN,
      false,
      100
    )

    Actions.stub(:rand, 0) do
      actual_state = Actions.move_snake(initial_state)
      assert_equal actual_state, expected_state
    end
  end
end