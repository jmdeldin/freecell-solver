class Array
  # Returns the row, col index of an element
  def index2d(needle)
    each_index do |i|
      j = self[i].index(needle)
      return [i, j] if j
    end
    nil
  end
end
