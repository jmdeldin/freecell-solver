$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

module FreeCell; end

require 'algorithms'
require 'set'

%w(
ext/array
card
reader
move
column_to_column_move
column_to_foundation_move
column_to_free_move
free_to_column_move
free_to_foundation_move
problem
node
solver
bfs_solver
dfs_solver
priority_solver
ucs_solver
greedy_solver
astar_solver
).each { |m| require "free_cell/#{m}" }
