module FreeCell
  # Moving an exposed card from a column to a foundation.
  class ColumnToFoundationMove < Move

    def initialize(problem, card)
      @problem  = problem
      @card     = card
      @executed = false
      @column_index = problem.columns.index2d card
    end

    # It is valid to move the card into a foundation if it is one larger than
    # the foundation card.
    def valid?
      last_found = suit_foundation.last
      return @card.ace? if last_found.nil?

      @card.sequentially_larger_than?(last_found)
    end

    def execute
      # remove free card from free cells
      @problem.columns[@column_index[0]].delete_at @column_index[1]

      # insert into foundation
      suit_foundation << @card

      @executed = true
    end

    def key
      s = @card.suit.to_s.upcase[0].chr
      "Col[#{@card}]->Fo[#{s}]"
    end

    def to_s
      return 'no move made' unless @executed

      "#{@card} from cascade #{@column_index[0]} to #{@card.suit} foundation"
    end

    private

    def suit_foundation
      @problem.foundations[@card.suit]
    end
  end
end
