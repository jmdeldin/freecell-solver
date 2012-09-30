require 'spec_helper'
require 'ostruct'

module FreeCell
  describe FreeToFoundationMove do
    let(:problem) do
      OpenStruct.new({ :free_cells => [card, nil],
                       :foundations => {:spades => [], :hearts => []} })
    end

    subject(:move) { FreeToFoundationMove.new(problem, card) }

    context 'given an ace in a free cell and empty foundations' do
      let(:card) { Card.from_string('AH') }

      its(:valid?) { should be_true }
      it 'moves the ace to the foundation' do
        move.execute
        move.to_s.should == "AH from free cell 0 to hearts foundation"
      end
    end

    context 'given a 2H in a free cell and an AH in a foundation' do
      let(:card) { Card.from_string('2H') }
      before(:each) { problem.foundations[:hearts] << Card.from_string('AH') }

      its(:valid?) { should be_true }
      it 'moves the 2H to the foundation' do
        move.execute
        move.to_s.should == "2H from free cell 0 to hearts foundation"
        problem.foundations[:hearts].map { |c| c.to_s }.should == %w(AH 2H)
      end
    end

    context 'given a QS in a free cell and an AS in a foundation' do
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
