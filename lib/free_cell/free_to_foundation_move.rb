module FreeCell
  # Moving a card from a free cell to a foundation.
  class FreeToFoundationMove < Move

    def initialize(state, card, card_index)
      super()
      @state      = state
      @card       = card
      @card_index = card_index
    end

    # It is valid to move the card into a foundation if it is one larger than
    # the foundation card.
    def valid?
      last_found = suit_foundation.last

      # valid to insert if the foundation is blank and we have an ace
      return @card.ace? if last_found.nil?

      @card.sequentially_larger_than?(last_found)
    end

    def execute
      # remove free card from free cells
      @state.free_cells[@card_index] = nil

      # insert into foundation
      suit_foundation << @card

      @executed = true
    end

    def key
      s = @card.suit.to_s.upcase[0].chr
      "Fr[#{@card}]->Fo[#{s}]"
    end

    def to_s
      return 'no move made' unless @executed

      "#{@card} from free cell #{@card_index} to #{@card.suit} foundation"
    end

    private

    def suit_foundation
      @state.foundations[@card.suit]
    end
  end
end
