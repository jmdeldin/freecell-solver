require 'spec_helper'
require 'ostruct'

describe FreeCell::Problem do
  let(:columns) do
    [
      [ FreeCell::Card.from_string('2H'), FreeCell::Card.from_string('AS') ],
      [ FreeCell::Card.from_string('2S'), FreeCell::Card.from_string('AH') ],
    ]
  end

  let(:opts) { {:columns => columns, :num_foundations => 2} }

  describe '#solved?' do
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

  describe '#actions' do
    context 'when the board only contains an ace' do
      let(:ace) { FreeCell::Card.new('A', :hearts) }
      subject(:pr) {
        FreeCell::Problem.new(:columns => [ace])
      }

      it 'moves the ace to the foundation' do
        pr.should_receive(:current_card).and_return(ace)
        pr.actions.should == [:move_to_foundation]
      end
    end
  end
end
