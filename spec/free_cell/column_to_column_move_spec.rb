require 'spec_helper'
require 'ostruct'

module FreeCell
  describe ColumnToColumnMove do
    let(:state) do
      OpenStruct.new({ :columns => [target_col, [card]],
                       :foundations => {:spades => [], :hearts => []} })
    end
    let(:target_idx) { 0 }
    let(:opts) { {:state => state, :card => card, :target_idx => target_idx, :card_index => [1, 0]}}

    subject(:move) { described_class.new(opts) }

    context 'with a blank column' do
      let(:target_col) { [] }
      let(:card) { Card.from_string('QH') }

      its(:valid?) { should be_true }
      its(:key) { should == "Col[QH]->Col[]" }

      describe '#execute' do
        before(:each) { move.execute }
        it 'moves the QH to the blank cascade' do
          move.to_s.should == "QH from cascade 1 to cascade 0"
        end
        it 'updates the position of the card' do
          state.columns[1].should be_empty
          state.columns[target_idx].should == [card]
        end
      end
    end

    context 'with a bigger card in the left column' do
      let(:other_card) { Card.from_string('KS') }
      let(:target_col) { [other_card] }
      let(:card) { Card.from_string('QH') }

      its(:valid?) { should be_true }
      its(:key) { should == "Col[QH]->Col[KS]" }
      it 'moves the QH on top of the KS' do
        move.execute
        move.to_s.should == "QH from cascade 1 to cascade 0"
        state.columns[1].should be_empty
        state.columns[target_idx].should == [other_card, card]
      end
    end

    context 'with cards of the same value' do
      let(:card) { Card.from_string('QS') }
      let(:other_card) { Card.from_string('QH') }
      let(:target_col) { [other_card] }
      its(:valid?) { should be_false }
    end

    context 'with a much too big card in the left column' do
      let(:card) { Card.from_string('2H') }
      let(:other_card) { Card.from_string('KS')}
      let(:target_col) { [other_card] }
      its(:valid?) { should be_false }
    end
  end
end
