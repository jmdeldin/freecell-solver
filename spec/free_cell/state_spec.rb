require 'spec_helper'

module FreeCell
  describe State do
    describe '.generate_goal_state' do
      it 'makes columns and free cells empty' do
        g = State.generate_goal_state
        g.columns.should be_empty
        g.free_cells.should be_empty
      end

      context 'with 2 cards' do
        it 'returns Aces and Twos' do
          g = State.generate_goal_state(:num_cards => 2)
          g.foundations[:spades].map { |c| c.face }.should == ["A", "2"]
        end
      end

      context 'with 4 suits' do
        it 'returns hearts, clubs, diamonds, and spades' do
          g = State.generate_goal_state(:num_suits => 4)
          [:hearts, :clubs, :diamonds, :spades].each do |suit|
            g.foundations[suit].length.should == 13
          end
        end
      end
    end

    describe '#==' do
      it 'returns true for the same attributes' do
        g1 = State.generate_goal_state()
        g2 = State.generate_goal_state()
        expect(g1).to eql g2
      end
    end

    describe '#hash' do
      it 'identifies two elements with the same attributes as identical' do
        g1 = State.generate_goal_state()
        g2 = State.generate_goal_state()
        h  = {g1 => :foo}
        h.include?(g2).should be_true
      end
    end
  end
end
