module FreeCell
  class BfsSolver < Solver
    def initialize(problem)
      super(problem, Containers::Queue.new)
    end
  end
end
