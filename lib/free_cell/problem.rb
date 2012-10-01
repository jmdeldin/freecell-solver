module FreeCell
  # Represents a problem to be solved by an intelligence agent.
  class Problem
    def initialize(state, goal)
      @state = state
      @goal  = goal
    end

    # Whether our current state is the goal state.
    def solved?
      @state == @goal
    end

    # Returns the available actions based on the current columns, free cells,
    # and foundations.
    def actions
      actions = []

      @state.free_cells.each_with_index do |free_cell, i|
        next if free_cell.nil?
        m = FreeToFoundationMove.new(@state, free_cell, i)
        actions << m if m.valid?
      end

      # last card in column moves
      @state.columns.each_with_index do |column, i|
        card = column.last
        next if card.nil?

        m1 = ColumnToFoundationMove.new(@state, card, i)
        actions << m1 if m1.valid?

        m2 = ColumnToFreeMove.new(@state, card, i)
        actions << m2 if m2.valid?
      end


      # column to column -- for each end card in each column...
      @state.columns.each_with_index do |column, i|
        card = column.last
        idx  = [i, column.index(card)]
        next if card.nil? # no need to try moving a blank...
        opts = { :state => @state, :card => card, :card_index => idx }

        @state.columns.each_with_index do |target_col, j|
          next if i == j

          opts[:target_idx] = j
          m = ColumnToColumnMove.new(opts)
          actions << m if m.valid?
        end
      end

      # free to column
      opts = {:state => @state}
      @state.free_cells.each_with_index do |free_cell, i|
        next if free_cell.nil?
        opts.merge!({:card => free_cell, :card_index => i})
        @state.columns.each_with_index do |target_col, target_idx|
          opts[:target_idx] = target_idx
          m = FreeToColumnMove.new(opts)
          actions << m if m.valid?
        end
      end

      actions
    end
  end
end
