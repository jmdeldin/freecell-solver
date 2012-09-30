module FreeCell
  # Moving an exposed card from a column to a free cell.
  class ColumnToFreeMove < Move

    def initialize(problem, card)
      @problem  = problem
      @card     = card
      @executed = false
      @column_index = problem.columns.index2d card
    end

    # It is a valid move from a column to free cell if the free cell is blank.
    def valid?
      !!free_cell_index
    end

    def execute
      # remove exposed card from board
      @problem.columns[@column_index[0]].delete_at @column_index[1]

      # replace free cell
      @problem.free_cells[free_cell_index] = @card

      @executed = true
    end

    def key
      "Col[#{@card}]->Fr[#{free_cell_index}]"
    end

    def to_s
      return 'no move made' unless @executed

      "#{@card} from cascade #{@column_index[0]} to cell"
    end

    private

    def free_cell_index
      @free_cell_index ||= @problem.free_cells.index nil
    end
  end
end
