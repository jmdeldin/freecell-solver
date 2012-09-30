require 'spec_helper'
require 'ostruct'

module FreeCell
  describe FreeToColumnMove do
    let(:problem) do
      OpenStruct.new({ :columns => [[other_card]],
                       :num_foundations => 2,
                       :free_cells => [card] })
    end
    let(:opts) {{
        :problem => problem,
        :card => card,
        :card_index => 0,
        :target_idx => 0,
      }
    }

    context 'with a 2H in the free cell and a 3S on the board' do
      let(:other_card) { Card.from_string('3S') }
      let(:card) { Card.from_string('2H') }
      subject(:move) { FreeToColumnMove.new(opts) }

      its(:valid?) { should be_true }
      it 'moves 2H on top of 3S' do
        move.execute
        problem.free_cells.should == [nil]
        problem.columns.should == [[other_card, card]]
      end
    end
  end
end
