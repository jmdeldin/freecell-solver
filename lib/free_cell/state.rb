module FreeCell
  # Represents the state of the FreeCell game.
  #
  class State
    attr_accessor :columns, :foundations, :free_cells

    def initialize(columns, foundations, free_cells)
      @columns     = columns
      @foundations = foundations
      @free_cells  = free_cells
    end

    def eql?(other)
      self.class.equal?(other.class) &&
        @columns == other.columns &&
        @free_cells == other.free_cells &&
        @foundations == other.foundations
    end
    alias_method :==, :eql?

    def hash
      @columns.hash ^ @free_cells.hash ^ @foundations.hash
    end

    # Generate a pre-filled goal state.
    #
    def self.generate_goal_state(opts={})
      opts[:num_cards] ||= 13
      opts[:num_suits] ||= 2
      foundations = {:spades => [], :hearts => []}

      if opts[:num_suits] == 4
        foundations[:diamonds] = []
        foundations[:clubs]    = []
      end

      faces = %w(A 2 3 4 5 6 7 8 9 T J Q K)[0...opts[:num_cards]]

      foundations.each do |suit, cards|
        faces.each do |face|
          cards << Card.new(face, suit)
        end
      end

      self.new([], foundations, [])
    end
  end
end
