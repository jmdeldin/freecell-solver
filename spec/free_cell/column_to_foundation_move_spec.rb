require 'spec_helper'
require 'ostruct'

module FreeCell
  describe ColumnToFoundationMove do
    let(:problem) do
      OpenStruct.new({ :columns => [[card], []],
                       :foundations => {:spades => [], :hearts => []} })
    end

    subject(:move) { described_class.new(problem, card) }

    context 'given an ace in a a column' do
      let(:card) { Card.from_string('AH') }

      its(:valid?) { should be_true }
      it 'moves the ace to the foundation' do
        move.execute
        move.to_s.should == "AH from cascade 0 to hearts foundation"
        problem.columns.flatten.should be_empty
      end
      its(:key) { should == "Col[AH]->Fo[H]" }
    end

    context 'given a QS and an AS in a foundation' do
      let(:card) { Card.from_string('QS') }
      before(:each) { problem.foundations[:spades] << Card.from_string('AS') }
      its(:valid?) { should be_false }
    end

    context 'given a 2H in a free cell and an AS in a foundation' do
      let(:card) { Card.from_string('2H') }
      before(:each) { problem.foundations[:spades] << Card.from_string('AS') }
      its(:valid?) { should be_false }
    end
  end
end
