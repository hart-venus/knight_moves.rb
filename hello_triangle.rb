# frozen_string_literal: true

require 'ruby2d'
slide_sound = Sound.new('slide.mp3')
knight_location = [0, 0]

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

Rectangle.new(
  x: 0,
  y: BOARD_SIZE - 20,
  width: BOARD_SIZE,
  height: TILE_SIZE + 20,
  color: [1, 1, 1, 0.85],
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

@my_knight = Image.new(
  'chessKnight.png',
  width: TILE_SIZE,
  height: TILE_SIZE,
  z: 1
)
on :mouse_down do |event|
  if event.y < BOARD_SIZE
    map_coords = world_to_map(event.x, event.y)
    knight_location = map_coords
    slide_sound.play
  end
end

def lerp(start, stop, step)
  (stop * step) + (start * (1.0 - step))
end

update do
  @my_knight.x = lerp(@my_knight.x, knight_location[0] * TILE_SIZE, 0.2)
  @my_knight.y = lerp(@my_knight.y, knight_location[1] * TILE_SIZE, 0.2)
end
draw_board
show
