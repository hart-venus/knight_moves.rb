require 'ruby2d'

BOARD_SIZE = 840
TILE_SIZE = BOARD_SIZE/8
BLACK_COLOR = '#6b7ee7'
WHITE_COLOR = '#ffd8cc'


set title: 'knight_moves.rb'
set width: BOARD_SIZE
set height: BOARD_SIZE
set background: 'black'

def draw_board
  81.times do |time|
    if time.even?
      Square.new(
        size:TILE_SIZE, color: WHITE_COLOR,
        x:time%9*TILE_SIZE,
        y:(time/9).to_i*TILE_SIZE
      )
    else
      Square.new(
        size:TILE_SIZE, color: BLACK_COLOR,
        x:time%9*TILE_SIZE,
        y:(time/9).to_i*TILE_SIZE
      )
    end
  end
end

def world_to_map(x,y)
  [(x / TILE_SIZE).to_i,(y / TILE_SIZE).to_i]
end

my_knight = Image.new(
  'chessKnight.png',
  width: TILE_SIZE,
  height: TILE_SIZE,
  z: 1
)
on :mouse_down do |event|
  map_coords = world_to_map(event.x, event.y)
  my_knight.x = map_coords[0] * TILE_SIZE
  my_knight.y = map_coords[1] * TILE_SIZE
end

draw_board
show