module FreeCell
  # Generic graph search.
  class Solver
    attr_reader :counts, :solution, :path_length

    def initialize(problem, frontier)
      @frontier = frontier
      @counts   = 0
      @solution = nil
      @problem  = problem
      @marked   = Set.new
      run
      compute_path
    end

    def run
      root = Node.new(@problem.state)
      @frontier.push root
      @marked << root

      until @frontier.empty?
        node = @frontier.pop

        if node.state == @problem.goal
          @solution = node
          return @solution
        end

        @problem.actions_for(node.state).each do |action|
          action.state = node.state.clone
          action.execute

          new_node = Node.new(action.state)
          new_node.action = action
          new_node.parent = node

          unless @marked.include? new_node.state
            @marked << new_node
            @frontier.push new_node
          end
        end

      end

      STDERR.puts "No solution"
    end

    def compute_path
      @nodes = []
      @path_length = -1 # skip the root

      cur = @solution
      while cur
        @nodes.unshift cur # prepend
        @path_length += 1
        cur = cur.parent
      end
    end

    def num_steps
      @path_length
    end

    def steps
      puts "Number of steps: #{num_steps}"
    end

    def descriptions
      steps
      puts "Log:"
      puts @nodes.map { |n| n.move }.join("\n")
    end
    alias_method :show_descriptions, :descriptions

    def show_boards
      descriptions
      puts "\nCascade history:"
      @nodes.each do |n|
        next if n.move.nil?
        puts n.move.state.print_state
      end
    end

    def progress_report
      puts @counts if (@counts % 1000) == 0
    end
  end
end
