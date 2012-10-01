class FreeCell::Node
  attr_reader :parent, :state, :cost
  attr_accessor :action

  def initialize(state)
    @state      = state
    @cost       = 0
    @action     = nil
  end

  def parent=(new_parent)
    @parent = new_parent
    if new_parent
      @cost = new_parent.cost + 1
    end
  end

  def hash
    @parent.hash ^ @state.hash
  end

  def eql?(other)
    self.class.equal?(other.class) &&
      @state == other.state &&
      @parent == other.parent
  end
  alias_method :==, :eql?
end

class FreeCell::NodePrinter
  def initialize(tail)
    @tail  = tail
    @nodes = []

    cur = tail
    while cur
      @nodes.unshift cur
      cur = cur.parent
    end
  end

  def steps
    "Number of steps: #{@tail.cost}"
  end

  def moves
    s = [steps]
    @nodes.each do |node|
      if node.action
        s << node.action.to_s
      end
    end
    s.join("\n")
  end

  def states
    s = [steps]
    @nodes.each do |node|
      if node.action
        s << node.action.to_s
        s << node.state.to_s
      else
        s << "Initial configuration"
        s << node.state.to_s
      end
    end
    s.join("\n")
  end
end
