module FreeCell
  class GreedySolver < PrioritySolver
    def initialize(problem)
      priority = lambda { |graph| graph.problem.heuristic }
      super(problem, priority)
    end
  end
end
