module FreeCell
  # Moving a free cell card to a column.
  class FreeToColumnMove < Move

    def initialize(opts)
      super()
      @state      = opts.fetch :state
      @card       = opts.fetch :card
      @card_index = opts.fetch :card_index
      @target_idx = opts.fetch :target_idx
      @target_col = @state.columns[@target_idx]
      @last_card  = @target_col.last
    end

    def valid?
      return true if @last_card.nil?

      @last_card.different_color?(@card) &&
        @last_card.sequentially_larger_than?(@card)
    end

    def execute
      # remove the card from the free cell
      @state.free_cells[@card_index] = nil

      # put it on the new cascade
      @target_col << @card
      @executed = true
    end

    def key
      "Fr[#{@card}]->Col[#{@last_card}]"
    end

    def to_s
      return 'no move made' unless @executed

      "#{@card} from cascade #{@card_index[0]} to cascade #{@target_idx}"
    end
  end
end
