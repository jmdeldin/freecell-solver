module FreeCell
  class Problem
    attr_reader :free_cells, :foundations, :columns

    def initialize(opts)
      @columns = opts.fetch :columns

      @num_foundations = opts[:num_foundations] || 2
      @foundations = {:spades => [], :hearts => []}
      if @num_foundations == 4
        @foundations.merge!({:diamonds => [], :clubs => []})
      end

      if opts[:free_cells]
        @free_cells = opts[:free_cells]
      else
        @free_cells = Array.new(opts[:num_free_cells] || 4)
      end
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
        next if free_cell.nil?
        m = FreeToFoundationMove.new(self, free_cell)
        actions << m if m.valid?
      end

      # last card in column moves
      @columns.each do |column|
        card = column.last
        next if card.nil?

        m1 = ColumnToFoundationMove.new(self, card)
        actions << m1 if m1.valid?

        m2 = ColumnToFreeMove.new(self, card)
        actions << m2 if m2.valid?
      end

      # column to column -- for each end card in each column...
      @columns.each_with_index do |column, i|
        card = column.last
        idx  = [i, column.index(card)]
        next if card.nil? # no need to try moving a blank...
        opts = { :problem => self, :card => card, :card_index => idx }

        @columns.each_with_index do |target_col, j|
          next if i == j

          opts[:target_idx] = j
          m = ColumnToColumnMove.new(opts)
          actions << m if m.valid?
        end
      end

      actions
    end
  end
end
