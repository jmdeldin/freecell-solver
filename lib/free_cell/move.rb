# Move interface
class FreeCell::Move
  attr_accessor :state

  def initialize
    @executed = false
  end

  def execute; end
  def valid?; end
end
