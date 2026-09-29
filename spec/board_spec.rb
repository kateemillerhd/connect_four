require_relative "../lib/board"

RSpec.describe Board do
  describe "#initialize" do
    it "create a board with 6 rows" do
      board = Board.new

      expect(board.grid.length).to eq(6)
    end

    it "creates each row with 7 columns" do
      board = Board.new

      board.grid.each do |row|
        expect(row.length).to eq(7)
      end
    end
  end

  describe "#drop_piece" do
    it "places a piece at the bottom of the selected column" do
      board = Board.new

      board.drop_piece(0, "X")

      expect(board.grid[5][0]).to eq("X")
    end

    it "stacks pieces in the same column" do
      board = Board.new

      board.drop_piece(0, "X")
      board.drop_piece(0, "O")

      expect(board.grid[5][0]).to eq("X")
      expect(board.grid[4][0]).to eq("O")
    end

    it "returns false when the selected column is full" do
      board = Board.new

      6.times do
        board.drop_piece(0, "X")
      end

      result = board.drop_piece(0, "O")

      expect(result).to be false
    end

    it "returns false when the selected column is invalid" do
      board = Board.new

      result = board.drop_piece(7, "X")

      expect(result).to be false
    end
  end

  describe "#winner?" do
    it "returns true when there are four matching pieces in a row horizontally" do
      board = Board.new

      board.drop_piece(0, "X")
      board.drop_piece(1, "X")
      board.drop_piece(2, "X")
      board.drop_piece(3, "X")

      expect(board.winner?("X")).to be true
    end

    it "returns false when there are not four matching pieces" do
      board = Board.new

      board.drop_piece(0, "X")
      board.drop_piece(1, "X")
      board.drop_piece(2, "X")

      expect(board.winner?("X")).to be false
    end

    it "returns true when there are four matching pieces in a row vertically" do
      board = Board.new

      4.times do
        board.drop_piece(0, "X")
      end

      expect(board.winner?("X")).to be true
    end

    it "returns true for a diagonal win from bottom-left to top-right" do
      board = Board.new

      board.drop_piece(0, "X")

      board.drop_piece(1, "O")
      board.drop_piece(1, "X")

      2.times { board.drop_piece(2, "O") }
      board.drop_piece(2, "X")

      3.times { board.drop_piece(3, "O") }
      board.drop_piece(3, "X")

      expect(board.winner?("X")).to be true
    end

    it "returns true for a diagonal win from bottom-right to top-left" do
      board = Board.new

      board.drop_piece(5, "X")

      board.drop_piece(4, "O")
      board.drop_piece(4, "X")

      2.times { board.drop_piece(3, "O") }
      board.drop_piece(3, "X")

      3.times { board.drop_piece(2, "O") }
      board.drop_piece(2, "X")

      expect(board.winner?("X")).to be true
    end

    it "returns false when the four matching pieces belong to the other player" do
      board = Board.new

      board.drop_piece(0, "O")
      board.drop_piece(1, "O")
      board.drop_piece(2, "O")
      board.drop_piece(3, "O")

      expect(board.winner?("X")).to be false
    end
  end

  describe "#four_in_a_row?" do
    it "returns true when there are four consecutive matching pieces" do
      board = Board.new

      cells = [nil, "X", "X", "X", "X", nil, nil]

      expect(board.four_in_a_row?(cells, "X")).to be true
    end

    it "returns false when matching pieces are not consecutive" do
      board = Board.new

      cells = ["X", "X", nil, "X", "X", nil, nil]

      expect(board.four_in_a_row?(cells, "X")).to be false
    end
  end
  
  describe "#display" do
    it "displays an empty board" do
      board = Board.new

      expected = "| | | | | | | |\n" \
                 "| | | | | | | |\n" \
                 "| | | | | | | |\n" \
                 "| | | | | | | |\n" \
                 "| | | | | | | |\n" \
                 "| | | | | | | |\n" \
                 "---------------\n" \
                 " 0 1 2 3 4 5 6\n"

      expect { board.display }.to output(expected).to_stdout
    end

    it "displays pieces on the board" do
      board = Board.new

      board.drop_piece(0, "X")
      board.drop_piece(1, "O")

      expected = "| | | | | | | |\n" \
                 "| | | | | | | |\n" \
                 "| | | | | | | |\n" \
                 "| | | | | | | |\n" \
                 "| | | | | | | |\n" \
                 "|X|O| | | | | |\n" \
                 "---------------\n" \
                 " 0 1 2 3 4 5 6\n"

      expect { board.display }.to output(expected).to_stdout
    end
  end     
  
  describe "#full?" do
    it "returns false when the board has empty spaces" do
      board = Board.new

      expect(board.full?).to be false
    end

    it "returns true when the board has no empty spaces" do
      board = Board.new

      7.times do |column|
        6.times do
          board.drop_piece(column, "X")
        end
      end

      expect(board.full?).to be true
    end
  end
end