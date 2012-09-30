class FreeCell::Problem
  def initialize(opts)
    @columns = opts.fetch :columns
  end

  # See if our goal state is true, which is when all of the foundations are
  # filled. To avoid iterating and comparing each foundation, we assume that
  # empty columns and empty free cells means all of the foundations are
  # filled. This assumes there was no wind on the table making cards
  # disappear.
  #
  # TODO: This might need to be optimized to avoid potentially expensive array
  # length calls.
  def solved?
    empty_columns? && empty_free_cells?
  end

  def empty_columns?
    @columns.flatten.empty?
  end

  def empty_free_cells?
    @free_cells.empty?
  end
end
