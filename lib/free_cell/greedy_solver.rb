module FreeCell
  class GreedySolver < PrioritySolver
    def initialize(problem)
      priority = lambda { |graph| graph.state.heuristic }
      super(problem, priority)
    end
  end
end
