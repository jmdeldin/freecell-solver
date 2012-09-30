require 'spec_helper'
require 'stringio'

describe FreeCell::Reader do
  let(:deal) { "2H AH\n2S AS" }
  let(:left_col) do
    [
      FreeCell::Card.new('2', :spades),
      FreeCell::Card.new('A', :spades),
    ]
  end
  let(:right_col) do
    [
      FreeCell::Card.new('2', :hearts),
      FreeCell::Card.new('A', :hearts),
    ]
  end
  let(:file) { StringIO.new(" \n#comment\n2\n2 #comment\n2\n2\n1\n2\n" + deal) }
  subject(:reader) { described_class.new(file) }

  it 'sets the correct algorithm' do
    reader.algorithm.should == :bfs
  end

  it 'sets the correct verbosity' do
    reader.verbosity.should == :board
  end

  it 'sets the correct deal' do
    reader.columns.should == [right_col, left_col]
  end
end
