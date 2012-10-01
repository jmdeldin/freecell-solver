module FreeCell
  class UcsSolver < PrioritySolver
    def initialize(problem)
      priority = lambda { |graph| graph.cost }
      super(problem, priority)
    end
  end
end
