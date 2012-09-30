module FreeCell
  # Moving a card from a free cell to a foundation.
  class FreeToFoundationMove < Move

    # [Problem] problem -- problem state
    # [Card]    card    -- card from a free cell
    def initialize(problem, card)
      @problem  = problem
      @card     = card
      @free_cell_index = @problem.free_cells.index @card
      @executed = false
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
      @problem.free_cells.delete_at @free_cell_index

      # insert into foundation
      suit_foundation << @card

      @executed = true
    end

    def to_s
      return 'no move made' unless @executed

      "#{@card} from free cell #{@free_cell_index} to #{@card.suit} foundation"
    end

    private

    def suit_foundation
      @problem.foundations[@card.suit]
    end
  end
end
