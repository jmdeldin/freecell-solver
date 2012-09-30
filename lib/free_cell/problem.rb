module FreeCell
  class Problem
    def initialize(opts)
      @columns = opts.fetch :columns

      @num_foundations = opts[:num_foundations] || 2
      @foundations = {:spades => [], :hearts => []}
      if @num_foundations == 4
        @foundations.merge!({:diamonds => [], :clubs => []})
      end

      @free_cells = Array.new(opts[:num_free_cells] || 4)
    end

    # See if our goal state is true, which is when all of the foundations are
    # filled. To avoid iterating and comparing each foundation, we assume that
    # empty columns and empty free cells means all of the foundations are
    # filled. This assumes there was no wind on the table making cards
    # disappear.
    #
    # TODO: This might need to be optimized to avoid potentially expensive array
    # length calls.
    def solved?
      empty_columns? && empty_free_cells?
    end

    def empty_columns?
      @columns.flatten.empty?
    end

    def empty_free_cells?
      @free_cells.empty?
    end

    def empty_foundations?
      @foundations.flatten.empty?
    end

    def can_insert_into_foundation?(card)
      f = @foundations[card.suit]

      card.face == 'A' || card.sequentially_larger_than?(f.last)
    end


    # Returns the available actions based on the current columns, free cells,
    # and foundations.
    def actions
      actions = []

      # free cell to foundation
      @free_cells.each do |free_cell|
        m = FreeToFoundationMove.new(self, free_cell)
        # actions << m if m.valid?
      end

      # last exposed card to foundation
      # column to column
      # column to free

      # if can_insert_into_foundation? c
      #   actions << :move_to_foundation
      # end

    end
  end
end
