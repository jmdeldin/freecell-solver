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
    context 'when an AH is in a free cell' do
      subject(:pr) do
        FreeCell::Problem.new(:columns => [],
                          :free_cells => [FreeCell::Card.from_string('AH')])
      end

      it 'suggests moving to a foundation' do
        pr.actions.map { |m| m.key }.should include "Fr[AH]->Fo[H]"
      end
    end

    context 'when a JH is in a free cell but no foundations to insert into' do
      subject(:pr) do
        FreeCell::Problem.new(:columns => [],
                          :free_cells => [FreeCell::Card.from_string('JH')])
      end

      it 'does not suggest moving to a foundation' do
        pr.actions.should be_empty
      end
    end

    context 'when the board only contains an ace' do
      let(:ace) { FreeCell::Card.new('A', :hearts) }
      subject(:pr) {
        FreeCell::Problem.new(:columns => [[ace]])
      }

      it 'moves the ace to the foundation' do
        pr.actions.map { |a| a.key }.should == ["Col[AH]->Fo[H]"]
      end
    end
  end
end
