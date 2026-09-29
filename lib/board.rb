class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(6) { Array.new(7) }
  end

  def drop_piece(column, piece)
    return false unless (0..6).include?(column)
    
    5.downto(0) do |row|
      if @grid[row][column].nil?
        @grid[row][column] = piece
        return true
      end
    end

    false
  end

  def winner?(piece)
    @grid.each do |row|
      return true if four_in_a_row?(row, piece)
    end

    (0..6).each do |column|
      column_cells = (0..5).map do |row|
        @grid[row][column]
      end

      return true if four_in_a_row?(column_cells, piece)
    end

    (3..5).each do |row|
      (0..3).each do |column|
        diagonal_cells = [
          @grid[row][column],
          @grid[row - 1][column + 1],
          @grid[row - 2][column + 2],
          @grid[row - 3][column + 3]
        ]

        return true if four_in_a_row?(diagonal_cells, piece)
      end
    end

    (3..5).each do |row|
      (3..6).each do |column|
        diagonal_cells = [
          @grid[row][column],
          @grid[row - 1][column - 1],
          @grid[row - 2][column - 2],
          @grid[row - 3][column - 3]
        ]
        
        return true if four_in_a_row?(diagonal_cells, piece)
      end
    end

    false
  end

  def four_in_a_row?(cells, piece)
    count = 0

    cells.each do |cell|
      if cell == piece
        count += 1
      else
        count = 0
      end

      return true if count == 4
    end

    false
  end

  def display
    @grid.each do |row|
      display_row = row.map do |cell|
        cell.nil? ? " " : cell
      end

      puts "|" + display_row.join("|") + "|"
    end

    puts "---------------"
    puts " 0 1 2 3 4 5 6"
  end

  def full?
    !@grid.any? do |row|
      row.any?(&:nil?)
    end
  end
end