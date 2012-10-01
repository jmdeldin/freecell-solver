module FreeCell
  class Solver
    attr_reader :counts, :solution

    def initialize(problem, frontier)
      @frontier = frontier
      @counts = 0
      @solution = nil
      @problem = problem
      run
      compute_path
    end

    def run
      g = Node.new(@problem)
      @frontier.push g
      marked = Set.new
      marked.add g.board

      until @frontier.empty?
        ng = @frontier.pop

        return @solution = ng if ng.problem.solved?
        @counts += 1
        progress_report

        # for every action, create some separate graphs
        ng.problem.actions.each do |action|
          action.problem = ng.problem.clone
          action.execute
          new_graph = Node.new(action.problem.clone, ng, action)

          unless marked.include? new_graph.board
            marked.add new_graph.board
            @frontier.push new_graph
          end
        end
      end
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

    def show_boards
      descriptions
      puts "\nCascade history:"
      @nodes.each do |n|
        next if n.move.nil?
        puts n.move.problem.print_state
      end
    end

    def progress_report
      puts @counts if (@counts % 1000) == 0
    end
  end
end
