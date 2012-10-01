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
      @free_cells.compact.empty?
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

      @free_cells.each do |free_cell|
        next if free_cell.nil?

        # free cell to foundation
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

      # free to column
      opts = {:problem => self}
      @free_cells.each_with_index do |free_cell, i|
        next if free_cell.nil?
        opts.merge!({:card => free_cell, :card_index => i})
        @columns.each_with_index do |target_col, target_idx|
          opts[:target_idx] = target_idx
          m = FreeToColumnMove.new(opts)
          actions << m if m.valid?
        end
      end

      actions
    end

    def eql?(other)
      self.class.equal?(other.class) && @columns == other.columns &&
        @free_cells == other.free_cells &&
        @foundations == other.foundations
    end
    alias_method :==, :eql?

    def hash
      @columns.hash ^ @free_cells.hash ^ @foundations.hash
    end

    # For #clone to work as expected, we need to clone the instance variables we
    # care about (board and blank position).
    def initialize_copy(source)
      super(source)

      @foundations = {}
      source.foundations.each { |k, v| @foundations[k] = v.clone }
      @columns     = []
      source.columns.each { |x| @columns << x.clone }
      @free_cells  = []
      source.free_cells.each do |x|
        if x.nil?
          @free_cells << x
        else
          @free_cells << x.clone
        end
      end
    end

    # Return a representation for comparison in sets
    def board
      {:columns => @columns, :foundations => @foundations}.values.to_s
    end

    def print_state
      puts "free cells:  " + @free_cells.join("|")
      puts "foundations: " + @foundations.inspect
      puts "................"
      @columns.each do |col|
        puts col.join(" ") unless col.empty?
      end
      puts "................"
    end

    def heuristic
      @columns.flatten.size
    end
  end
end
