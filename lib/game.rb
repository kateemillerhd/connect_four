class Game
  attr_reader :board, :players, :current_player

  def initialize(board, player_one, player_two)
    @board = board
    @players = [player_one, player_two]
    @current_player = player_one
  end
  
  def switch_player
    if @current_player == @players[0]
      @current_player = @players[1]
    else
      @current_player = @players[0]
    end
  end

  def play_turn(column)
    turn = @board.drop_piece(column, @current_player.piece)
   
    return false unless turn 
    
    return :win if @board.winner?(@current_player.piece) 

    switch_player    
  end

  def get_player_input
    print "#{@current_player.name}, choose a column (0-6): "
    
    input = gets.chomp

    return nil unless input.match?(/^\d+$/)
    
    input.to_i
  end

  def play

    loop do
      @board.display
      
      column = get_player_input
      result = play_turn(column)

      if result == :win
        @board.display
        puts "#{@current_player.name} wins!"
        break
      elsif result == false
        puts "Invalid move. Try again."
      elsif @board.full?
        @board.display
        puts "It's a draw!"
        break
      end
    end
  end
end