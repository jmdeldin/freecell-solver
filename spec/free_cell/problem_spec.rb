require 'spec_helper'
require 'ostruct'

describe FreeCell::Problem do
  let(:columns) do
    [
      [ FreeCell::Card.from_string('2H'), FreeCell::Card.from_string('AS') ],
      [ FreeCell::Card.from_string('2S'), FreeCell::Card.from_string('AH') ],
    ]
  end

  let(:opts) { {:columns => columns} }

  describe '#goal_state' do
    subject(:pr) { FreeCell::Problem.new(opts) }
    it 'returns true when the free cells and cascades are empty' do
      pr.should_receive(:empty_columns?).and_return(true)
      pr.should_receive(:empty_free_cells?).and_return(true)
      pr.solved?.should be_true
    end

    it 'returns false when the free cells are filled' do
      pr.should_receive(:empty_columns?).and_return(true)
      pr.should_receive(:empty_free_cells?).and_return(false)
      pr.solved?.should be_false
    end

    it 'returns false when the columns are filled' do
      pr.should_receive(:empty_columns?).and_return(false)
      pr.solved?.should be_false
    end

  end
end
