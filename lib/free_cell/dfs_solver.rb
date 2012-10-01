module FreeCell
  class DfsSolver < Solver
    def initialize(problem)
      super(problem, Containers::Stack.new)
    end
  end
end
