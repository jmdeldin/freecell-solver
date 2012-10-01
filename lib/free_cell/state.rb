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
        @free_cells == other.free_cells &&
        @columns == other.columns &&
        @foundations == other.foundations
    end
    alias_method :==, :eql?

    def hash
      @columns.hash ^ @free_cells.hash ^ @foundations.hash
    end

    # Deep-clone the attributes
    def initialize_copy(source)
      super(source)

      @columns = []
      source.columns.each { |c| @columns << c.clone }

      @foundations = {}
      source.foundations.each do |k, v|
        @foundations[k] = []
        v.each { |c| @foundations[k] << c.clone }
      end

      @free_cells = []
      source.free_cells.each do |fc|
        if fc.nil?
          @free_cells << fc
        else
          @free_cells << fc.clone
        end
      end
    end

    def to_s
      @columns.map { |row| "  " + row.join(" ") }.join("\n")
    end

    def inspect
      "<State id=#{object_id} columns=#{@columns.inspect} free_cells=#{@free_cells.inspect} foundations=#{@foundations.inspect}>"
    end

    def heuristic
      @columns.flatten.size
    end

    # Generate a pre-filled goal state.
    #
    def self.generate_goal_state(opts={})
      opts[:num_cards] ||= 13
      opts[:num_suits] ||= 2
      opts[:num_free_cells] ||= 4

      foundations = {:spades => [], :hearts => []}

      if opts[:num_suits] == 4
        foundations[:diamonds] = []
        foundations[:clubs]    = []
      end

      free_cells = Array.new(opts[:num_free_cells])

      faces = %w(A 2 3 4 5 6 7 8 9 T J Q K)[0...opts[:num_cards]]

      foundations.each do |suit, cards|
        faces.each do |face|
          cards << Card.new(face, suit)
        end
      end

      self.new(Array.new(opts[:num_suits], []), foundations, free_cells)
    end
  end
end
