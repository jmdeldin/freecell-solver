module FreeCell
  # Moving an exposed card from a column to a foundation.
  class ColumnToFoundationMove < Move

    def initialize(state, card, column_index)
      super()
      @state        = state
      @card         = card
      @column_index = column_index
    end

    # It is valid to move the card into a foundation if it is one larger than
    # the foundation card.
    def valid?
      last_found = suit_foundation.last
      return @card.ace? if last_found.nil?

      @card.sequentially_larger_than?(last_found)
    end

    def execute
      c = @state.columns[@column_index].pop
      suit_foundation << c
      @executed = true
    end

    def key
      s = @card.suit.to_s.upcase[0].chr
      "Col[#{@card}]->Fo[#{s}]"
    end

    def to_s
      return 'no move made' unless @executed

      "#{@card} from cascade #{@column_index} to #{@card.suit} foundation"
    end

    private

    def suit_foundation
      @state.foundations[@card.suit]
    end
  end
end
