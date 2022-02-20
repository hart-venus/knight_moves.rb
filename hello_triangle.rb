# frozen_string_literal: true

require 'ruby2d'

BOARD_SIZE = 840
TILE_SIZE = BOARD_SIZE / 8
BLACK_COLOR = '#660527'
WHITE_COLOR = '#ffd8cc'

set title: 'knight_moves.rb'
set width: BOARD_SIZE
set height: BOARD_SIZE + TILE_SIZE
set background: 'black'

Rectangle.new(
  x: 0,
  y: BOARD_SIZE,
  width: BOARD_SIZE,
  height: TILE_SIZE,
  z: 2
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

my_knight = Image.new(
  'chessKnight.png',
  width: TILE_SIZE,
  height: TILE_SIZE,
  z: 1
)
on :mouse_down do |event|
  if event.y < BOARD_SIZE
    map_coords = world_to_map(event.x, event.y)
    my_knight.x = map_coords[0] * TILE_SIZE
    my_knight.y = map_coords[1] * TILE_SIZE
  end
end

draw_board
show
