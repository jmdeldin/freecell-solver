module FreeCell
  # Moving an exposed card from a column to another column.
  class ColumnToColumnMove < Move

    def initialize(opts)
      super()
      @state      = opts.fetch :state
      @card       = opts.fetch :card
      @card_index = opts.fetch :card_index
      @target_idx = opts.fetch :target_idx
      @target_col = @state.columns[@target_idx]
      @last_card  = @target_col.last
    end

    # It is valid to move the card on top of another card if it's a different
    # color and one less than the target, or if the target is a blank cascade.
    def valid?
      return true if @last_card.nil?

      @last_card.different_color?(@card) &&
        @last_card.sequentially_larger_than?(@card)
    end

    def execute
      # remove the card from the old cascade
      c = @state.columns[@card_index[0]].pop
      # put it on the new cascade
      @target_col << c
      @executed = true
    end

    def key
      "Col[#{@card}]->Col[#{@last_card}]"
    end

    def to_s
      return 'no move made' unless @executed

      "#{@card} from cascade #{@card_index[0]} to cascade #{@target_idx}"
    end
  end
end
