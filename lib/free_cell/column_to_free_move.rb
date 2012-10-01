module FreeCell
  # Moving an exposed card from a column to a free cell.
  class ColumnToFreeMove < Move

    def initialize(state, card, column_index)
      super()
      @state      = state
      @card         = card
      @column_index = column_index
    end

    # It is a valid move from a column to free cell if the free cell is blank.
    def valid?
      !!free_cell_index
    end

    def execute
      # remove exposed card from board
      c = @state.columns[@column_index].pop

      # replace free cell
      @state.free_cells[free_cell_index] = c

      @executed = true
    end

    def key
      "Col[#{@card}]->Fr[#{free_cell_index}]"
    end

    def to_s
      return 'no move made' unless @executed

      "#{@card} from cascade #{@column_index} to cell"
    end

    private

    def free_cell_index
      @free_cell_index ||= @state.free_cells.index nil
    end
  end
end
