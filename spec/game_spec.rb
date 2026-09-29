require_relative "../lib/game"

RSpec.describe Game do
  describe "#initialize" do
    it "creates a game with a board and two players" do
      board = double("board")
      player_one = double("player_one")
      player_two = double("player_two")

      game = Game.new(board, player_one, player_two)

      expect(game.board).to eq(board)
      expect(game.players).to eq([player_one, player_two])
    end

    it "starts with player one as the current player" do
      board = double("board")
      player_one = double("player_one")
      player_two = double("player_two")

      game = Game.new(board, player_one, player_two)

      expect(game.current_player).to eq(player_one)
    end
  end

  describe "#switch_player" do
    it "switches from player one to player two" do
      board = double("board")
      player_one = double("player_one")
      player_two = double("player_two")

      game = Game.new(board, player_one, player_two)

      game.switch_player

      expect(game.current_player).to eq(player_two)
    end

    it "switches from player one to player two back to player one" do
      board = double("board")
      player_one = double("player_one")
      player_two = double("player_two")

      game = Game.new(board, player_one, player_two)

      game.switch_player
      game.switch_player

      expect(game.current_player).to eq(player_one)
    end
  end

  describe "#play_turn" do
    it "drops the current player's piece into the selected column" do
      board = double("board")
      player_one = double("player_one", piece: "X")
      player_two = double("player_two", piece: "O")

      game = Game.new(board, player_one, player_two)

      allow(board).to receive(:winner?).and_return(false)


      expect(board).to receive(:drop_piece).with(3, "X").and_return(true)

      game.play_turn(3)
    end

    it "switches players after a successful move" do
      board = double("board")
      player_one = double("player_one", piece: "X")
      player_two = double("player_two", piece: "O")

      game = Game.new(board, player_one, player_two)

      allow(board).to receive(:drop_piece).and_return(true)
      allow(board).to receive(:winner?).and_return(false)

      game.play_turn(3)

      expect(game.current_player).to eq(player_two)
    end

    it "does not switch players after an unsuccessful move" do
      board = double("board")
      player_one = double("player_one", piece: "X")
      player_two = double("player_two", piece: "O")

      game = Game.new(board, player_one, player_two)

      allow(board).to receive(:drop_piece).and_return(false)

      game.play_turn(3)

      expect(game.current_player).to eq(player_one)
    end

    it "returns false after an unsuccessful move" do
      board = double("board")
      player_one = double("player_one", piece: "X")
      player_two = double("player_two", piece: "O")

      game = Game.new(board, player_one, player_two)

      allow(board).to receive(:drop_piece).with(9, "X").and_return(false)

      result = game.play_turn(9)

      expect(result).to be false
    end

    it "returns :win when the current player makes a winning move" do
      board = double("board")
      player_one = double("player_one", piece: "X")
      player_two = double("player_two", piece: "O")

      game = Game.new(board, player_one, player_two)

      allow(board).to receive(:drop_piece).and_return(true)
      allow(board).to receive(:winner?).with("X").and_return(true)

      result = game.play_turn(3)

      expect(result).to eq(:win)
    end

    it "does not switch players after a winning move" do
      board = double("board")
      player_one = double("player_one", piece: "X")
      player_two = double("player_two", piece: "O")

      game = Game.new(board, player_one, player_two)

      allow(board).to receive(:drop_piece).and_return(true)
      allow(board).to receive(:winner?).and_return(true)

      game.play_turn(3)

      expect(game.current_player).to eq(player_one)
    end

    it "notifies the player when their move is invalid" do
      board = double("board")
      player_one = double("player_one", name: "Kate", piece: "X")
      player_two = double("player_two", name: "Bob", piece: "O")

      game = Game.new(board, player_one, player_two)

      allow(board).to receive(:display)
      allow(game).to receive(:get_player_input).and_return(8, 3)
      allow(game).to receive(:play_turn).and_return(false, :win)

      expect { game.play }
        .to output("Invalid move. Try again.\nKate wins!\n").to_stdout
    end
  end

  describe "#get_player_input" do
    it "asks the current player to choose a column" do
      board = double("board")
      player_one = double("player_one", name: "Kate", piece: "X")
      player_two = double("player_two", name: "Bob", piece: "O")

      game = Game.new(board, player_one, player_two)

      allow(game).to receive(:gets).and_return("3\n")

      expect { game.get_player_input }.to output("Kate, choose a column (0-6): ").to_stdout
    end

    it "returns the selected column as an integer" do
      board = double("board")
      player_one = double("player_one", name: "Kate", piece: "X")
      player_two = double("player_two", name: "Bob", piece: "O")

      game = Game.new(board, player_one, player_two)

      allow(game).to receive(:gets).and_return("3\n")
      allow(game).to receive(:print)

      result = game.get_player_input

      expect(result).to eq(3)
    end

    it "returns nil when the input is not a number" do
      board = double("board")
      player_one = double("player_one", name: "Kate", piece: "X")
      player_two = double("player_two", name: "Bob", piece: "O")

      game = Game.new(board, player_one, player_two)

      allow(game).to receive(:gets).and_return("hello\n")
      allow(game).to receive(:print)

      expect(game.get_player_input).to be nil
    end
  end

  describe "#play" do
    it "displays the board" do
      board = double("board")
      player_one = double("player_one", name: "Kate", piece: "X")
      player_two = double("player_two", name: "Bob", piece: "O")

      game = Game.new(board, player_one, player_two)

      allow(game).to receive(:get_player_input).and_return(3)
      allow(game).to receive(:play_turn).and_return(:win)
      allow(game).to receive(:puts)

      expect(board).to receive(:display).at_least(:once)

      game.play
    end

    it "gets input from the current player" do
      board = double("board")
      player_one = double("player_one", name: "Kate", piece: "X")
      player_two = double("player_two", name: "Bob", piece: "O")

      game = Game.new(board, player_one, player_two)

      allow(board).to receive(:display)
      allow(game).to receive(:play_turn).and_return(:win)
      allow(game).to receive(:puts)

      expect(game).to receive(:get_player_input).and_return(3)

      game.play
    end

    it "plays a turrn using the player's chosen column" do
      board = double("board")
      player_one = double("player_one", name: "Kate", piece: "X")
      player_two = double("player_two", name: "Bob", piece: "O")

      game = Game.new(board, player_one, player_two)

      allow(board).to receive(:display)
      allow(game).to receive(:get_player_input).and_return(3)

      expect(game).to receive(:play_turn).with(3).and_return(:win)

      game.play
    end

    it "announces the winner when the player wins" do
      board = double("board")
      player_one = double("player_one", name: "Kate", piece: "X")
      player_two = double("player_two", name: "Bob", piece: "O")

      game = Game.new(board, player_one, player_two)

      allow(board).to receive(:display)
      allow(game).to receive(:get_player_input).and_return(3)
      allow(game).to receive(:play_turn).with(3).and_return(:win)

      expect { game.play }
        .to output("Kate wins!\n").to_stdout
    end

    it "continues playing until a player wins" do
      board = double("board")
      player_one = double("player_one", name: "Kate", piece: "X")
      player_two = double("player_two", name: "Bob", piece: "O")

      game = Game.new(board, player_one, player_two)

      allow(board).to receive(:display)
      allow(board).to receive(:full?).and_return(false)
      allow(game).to receive(:get_player_input).and_return(3)
      allow(game).to receive(:play_turn).and_return(nil, :win)
      expect(game).to receive(:play_turn).twice
      allow(game).to receive(:puts)

      game.play
    end

    it "ends the game in a draw when the board is full" do
      board = double("board")
      player_one = double("player_one", name: "Kate", piece: "X")
      player_two = double("player_two", name: "Bob", piece: "O")

      game = Game.new(board, player_one, player_two)

      allow(board).to receive(:display)
      allow(board).to receive(:full?).and_return(true)
      allow(game).to receive(:get_player_input).and_return(3)
      allow(game).to receive(:play_turn).and_return(nil)

      expect { game.play }
        .to output("It's a draw!\n").to_stdout
    end

    it "displays the final board aftere a winning move" do
      board = double("board")
      player_one = double("player_one", name: "Kate", piece: "X")
      player_two = double("player_two", name: "Bob", piece: "O")

      game = Game.new(board, player_one, player_two)

      allow(game).to receive(:get_player_input).and_return(3)
      allow(game).to receive(:play_turn).and_return(:win)
      allow(game).to receive(:puts)

      expect(board).to receive(:display).twice

      game.play
    end

    it "displays the final board when the game ends in a draw" do
      board = double("board")
      player_one = double("player_one", name: "Kate", piece: "X")
      player_two = double("player_two", name: "Bob", piece: "O")

      game = Game.new(board, player_one, player_two)

      allow(game).to receive(:get_player_input).and_return(3)
      allow(game).to receive(:play_turn).and_return(nil)
      allow(board).to receive(:full?).and_return(true)
      allow(game).to receive(:puts)

      expect(board).to receive(:display).twice

      game.play
    end
  end
end 