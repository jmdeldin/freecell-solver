# Move interface
class FreeCell::Move
  def initialize(card); end
  def execute(card); end
  def valid_with?(card); end
end
