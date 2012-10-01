module FreeCell
  class PrioritySolver < Solver
    def initialize(problem, priority_func)
      @counts = 0
      @solution = nil
      @priority_func = priority_func
      run(problem)
      compute_path
    end

    def run(problem)
      g = Node.new(problem)
      frontier = Containers::PriorityQueue.new do |x, y|
        (y <=> x) == 1 # prefer smaller elts
      end

      frontier.push(g, @priority_func.call(g))
      marked = Set.new
      marked.add g.board
      explored = Set.new

      until frontier.empty?
        ng = frontier.pop

        return @solution = ng if ng.problem.solved?
        @counts += 1
        progress_report

        explored << ng.board

        # for every action, create some separate graphs
        ng.problem.actions.each do |action|
          action.problem = ng.problem.clone
          action.execute
          new_graph = Node.new(action.problem.clone, ng, action)

          if explored.include? new_graph.board
            next
          end

          unless marked.include? new_graph.board
            marked.add new_graph.board
            frontier.push(new_graph, @priority_func.call(new_graph))
          end
        end
      end
    end
  end
end
