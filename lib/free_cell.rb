$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

module FreeCell; end

require 'algorithms'
require 'set'

require 'free_cell/ext/array'
require 'free_cell/card'
require 'free_cell/reader'
require 'free_cell/move'
require 'free_cell/free_to_foundation_move'
require 'free_cell/column_to_foundation_move'
require 'free_cell/column_to_free_move'
require 'free_cell/column_to_column_move'
require 'free_cell/problem'
