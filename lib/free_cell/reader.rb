class FreeCell::Reader
  attr_reader :columns, :num_suits, :num_free

  def initialize(file_handle)
    @num_suits = @num_cards = @num_cols = @num_free = @verbosity = 0
    @columns = []

    parse(file_handle)
  end

  def algorithm
    {
      1 => :dfs,
      2 => :bfs,
      3 => :ucs,
      4 => :greedy,
      5 => :astar,
    }[@algo]
  end

  def verbosity
    case @verbosity
    when 0 then :show_steps
    when 1 then :show_descriptions
    when 2 then :show_boards
    end
  end

  def deal

  end

  private

  def parse(file_handle)
    i = 0
    file_handle.each_line do |line|
      next if line.strip! == ''
      next if line.gsub!(/#.*/, '') == ''

      case i
      when 0
        @algo = Integer(line)
      when 1
        @num_suits = Integer(line)
      when 2
        @num_cards = Integer(line)
      when 3
        @num_cols = Integer(line)
      when 4
        @num_free = Integer(line)
      when 5
        @verbosity = Integer(line)
      else
        @columns << line.split(' ')
      end

      i += 1
    end

    @columns.map! { |col| col.map! { |card| FreeCell::Card.from_string(card) } }
  end
end
