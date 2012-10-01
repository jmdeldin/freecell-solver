# Move interface
class FreeCell::Move
  attr_accessor :problem

  def execute; end
  def valid?; end
end
