module FreeCell
  class AstarSolver < PrioritySolver
    def initialize(problem)
      priority = lambda { |graph| graph.state.heuristic + graph.cost }
      super(problem, priority)
    end
  end
end
