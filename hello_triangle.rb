# frozen_string_literal: true

require 'ruby2d'
slide_sound = Sound.new('slide.mp3')
knight_location = [4, 4]
knight_location_b = [3, 4]

BOARD_SIZE = 840
TILE_SIZE = BOARD_SIZE / 8
BLACK_COLOR = '#660527'
WHITE_COLOR = '#ffd8cc'

set title: 'knight_moves.rb'
set width: BOARD_SIZE
set height: BOARD_SIZE + TILE_SIZE
set background: 'black'

Text.new(
  'Starting Position',
  font: 'Roboto-Black.ttf',
  size: 24,
  color: BLACK_COLOR,
  x: 20,
  y: BOARD_SIZE,
  z: 10
)

Text.new(
  'End Position',
  font: 'Roboto-Black.ttf',
  size: 24,
  color: BLACK_COLOR,
  x: 300,
  y: BOARD_SIZE,
  z: 10
)

@initial_position_label = Text.new(
  "#{knight_location[0]}, #{knight_location[1]}",
  font: 'Roboto-ThinItalic.ttf',
  size: 24,
  color: BLACK_COLOR,
  x: 80,
  y: BOARD_SIZE + 30,
  z: 10
)

@end_position_label = Text.new(
  "#{knight_location_b[0]}, #{knight_location_b[1]}",
  font: 'Roboto-ThinItalic.ttf',
  size: 24,
  color: BLACK_COLOR,
  x: 360,
  y: BOARD_SIZE + 30,
  z: 10
)

Rectangle.new(
  x: 0,
  y: BOARD_SIZE - 20,
  width: BOARD_SIZE,
  height: TILE_SIZE + 20,
  color: [1, 1, 1, 0.85],
  z: 3
)

Rectangle.new(
  x: 550,
  y: BOARD_SIZE,
  width: 160,
  height: 50,
  color: BLACK_COLOR,
  z: 12
)

Text.new(
  'Calculate',
  font: 'Roboto-ThinItalic.ttf',
  size: 24,
  color: WHITE_COLOR,
  x: 560,
  y: BOARD_SIZE + 20,
  z: 13
)

def draw_board
  81.times do |time|
    if time.even?
      make_square(WHITE_COLOR, time)
    else
      make_square(BLACK_COLOR, time)
    end
  end
end

def make_square(color, num)
  Square.new(
    size: TILE_SIZE, color: color,
    x: num % 9 * TILE_SIZE,
    y: (num / 9).to_i * TILE_SIZE
  )
end

def world_to_map(x_coord, y_coord)
  [(x_coord / TILE_SIZE).to_i, (y_coord / TILE_SIZE).to_i]
end

@my_knight = Image.new(
  'chessKnight.png',
  width: TILE_SIZE,
  height: TILE_SIZE,
  x: knight_location[0] * TILE_SIZE,
  y: knight_location[1] * TILE_SIZE,
  z: 2
)

@my_second_knight = Image.new(
  'chessKnightB.png',
  width: TILE_SIZE,
  height: TILE_SIZE,
  x: knight_location_b[0] * TILE_SIZE,
  y: knight_location_b[1] * TILE_SIZE,
  z: 1
)
on :mouse_down do |event|
  if event.y < BOARD_SIZE
    map_coords = world_to_map(event.x, event.y)
    slide_sound.play

    knight_location = map_coords if knight_location_b != map_coords && event.button == :left
    knight_location_b = map_coords if knight_location != map_coords && event.button == :right
  elsif event.y > 840 && event.y < 890 && event.x > 550 && event.x < 710
    p knight_location
    p calculate_moves([[knight_location]], knight_location_b)
  end
end

def calculate_moves(queue, towards)
  until queue.empty?
    current_move_series = queue.pop
    next unless current_move_series.uniq == current_move_series

    return current_move_series if current_move_series.last == towards

    calculate_possible_moves(current_move_series.last).each do |possible_move|
      new_move = current_move_series + [possible_move]
      queue.unshift(new_move)
    end
  end
end

def calculate_possible_moves(from)
  possible_moves = []
  possible_offsets = [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]]

  possible_offsets.each do |offset|
    move = [from[0] + offset[0], from[1] + offset[1]]
    possible_moves.append(move) if in_board?(move)
  end

  possible_moves
end

def in_board?(spot)
  return true if spot[0] < 8 && spot[0] > -1 && spot[1] < 8 && spot[1] > -1
end

def lerp(start, stop, step)
  (stop * step) + (start * (1.0 - step))
end

update do
  @my_knight.x = lerp(@my_knight.x, knight_location[0] * TILE_SIZE, 0.2)
  @my_knight.y = lerp(@my_knight.y, knight_location[1] * TILE_SIZE, 0.2)

  @my_second_knight.x = lerp(@my_second_knight.x, knight_location_b[0] * TILE_SIZE, 0.2)
  @my_second_knight.y = lerp(@my_second_knight.y, knight_location_b[1] * TILE_SIZE, 0.2)

  @initial_position_label.text = "#{knight_location[0]}, #{knight_location[1]}"
  @end_position_label.text = "#{knight_location_b[0]}, #{knight_location_b[1]}"
end

draw_board
show
