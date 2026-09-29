require_relative "lib/board"
require_relative "lib/player"
require_relative "lib/game"

board = Board.new

print "Player 1, 'X', enter your name: "
name_1 = gets.chomp

print "Player 2, 'O' enter your name: "
name_2 = gets.chomp

player_one = Player.new(name_1, "X")
player_two = Player.new(name_2, "O")

game = Game.new(board, player_one, player_two)

game.play