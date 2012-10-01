class FreeCell::Node
  attr_accessor :problem, :move, :cost
  attr_reader :parent

  def initialize(problem, parent=nil, move=nil)
    self.parent = parent
    @problem = problem
    @move = move
    @cost = 0
  end

  def parent=(np)
    @parent = np
    if np
      @cost = np.cost + 1
    end
  end

  def board
    @problem.board
  end
end
