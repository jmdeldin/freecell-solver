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
        pr.actions.map { |a| a.key }.should include "Col[AH]->Fo[H]"
      end
    end

    context 'when the board only contains a TH' do
      let(:card) { FreeCell::Card.new('T', :hearts) }
      subject(:pr) {
        FreeCell::Problem.new(:columns => [[card]])
      }

      it 'moves the TH to the free cell' do
        pr.actions.map { |a| a.key }.should include "Col[TH]->Fr[0]"
      end
    end

    context 'when the board contains a JC and a TD' do
      let(:card) { FreeCell::Card.from_string('JC') }
      let(:other_card) { FreeCell::Card.from_string('TD') }
      subject(:pr) {
        FreeCell::Problem.new({
                                :columns => [[card], [other_card]],
                                :num_free_cells => 0,
                                :num_foundations => 4
                              })
      }

      it 'moves the TD on top of the JC' do
        pr.actions.map { |a| a.key }.should include "Col[TD]->Col[JC]"
      end
    end

    context 'when the board contains 2H, a blank, 3S' do
      let(:card) { FreeCell::Card.from_string('2H') }
      let(:other_card) { FreeCell::Card.from_string('3S') }
      subject(:pr) {
        FreeCell::Problem.new({
                                :columns => [[], [other_card], [card]],
                                :num_free_cells => 0,
                                :num_foundations => 4
                              })
      }

      it 'suggests moving the 2H on top of the 3S' do
        pr.actions.map { |a| a.key }.should include "Col[2H]->Col[3S]"
      end

      it 'suggests moving the 2H to the blank' do
        pr.actions.map { |a| a.key }.should include "Col[2H]->Col[]"
      end

      it 'suggests moving the 3S to the blank' do
        pr.actions.map { |a| a.key }.should include "Col[3S]->Col[]"
      end
    end
  end
end
