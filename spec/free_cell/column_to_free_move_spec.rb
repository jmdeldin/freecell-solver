require 'spec_helper'
require 'ostruct'

module FreeCell
  describe ColumnToFreeMove do
    let(:card) { Card.from_string '2H' }
    let(:other_card) { Card.from_string 'TH' }
    let(:problem) { OpenStruct.new(:columns => [[card], []], :free_cells => free_cells) }
    subject(:move) { ColumnToFreeMove.new(problem, card) }

    context 'with a 2H on the board and all free cells' do
      let(:free_cells) { [other_card, nil] }
      its(:valid?) { should be_true }
      it 'moves the 2H to the free cell' do
        move.execute
        move.to_s.should == "2H from cascade 0 to cell"
        move.key.should == "Col[2H]->Fr[1]"
        problem.free_cells.should == [other_card, card]
        problem.columns.flatten.should be_empty
      end
    end

    context 'with a 2H on the board and no free cells' do
      let(:free_cells) { [] }
      its(:valid?) { should be_false }
    end
  end
end
