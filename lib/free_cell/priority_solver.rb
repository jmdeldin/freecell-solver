module FreeCell
  class PrioritySolver < Solver
    def initialize(problem, priority_func)
      @counts        = 0
      @problem       = problem
      @solution      = nil
      @priority_func = priority_func
      @marked        = Set.new
      @frontier      = Containers::PriorityQueue.new do |x, y|
        (y <=> x) == 1 # prefer smaller elts
      end

      run
      compute_path
    end

    def run
      root = Node.new(@problem.state)
      @frontier.push(root, @priority_func.call(root))
      @marked << root

      until @frontier.empty?
        node = @frontier.pop

        if node.state == @problem.goal
          @solution = node
          return @solution
        end

        progress_report

        @problem.actions_for(node.state).each do |action|
          action.state = node.state.clone
          action.execute

          new_node = Node.new(action.state)
          new_node.action = action
          new_node.parent = node

          unless @marked.include? new_node.state
            @marked << new_node
            @frontier.push(new_node, @priority_func.call(new_node))
          end
        end
      end
    end
  end
end
