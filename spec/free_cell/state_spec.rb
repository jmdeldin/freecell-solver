require 'spec_helper'

module FreeCell
  describe State do
    describe '.generate_goal_state' do
      it 'makes columns empty' do
        g = State.generate_goal_state
        g.columns.should be_empty
      end

      it 'makes free cells all nil' do
        g = State.generate_goal_state
        g.free_cells.should == [nil, nil, nil, nil]
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

    describe '#clone' do
      before(:each) do
        @g1 = State.generate_goal_state
        @g1.free_cells[0] = Card.from_string('2H')
        @g2 = @g1.clone
      end

      it 'deep clones columns' do
        @g1.columns.zip(@g2.columns) do |g1c, g2c|
          g1c.object_id.should_not == g2c.object_id
          g1c.should == g2c
        end
      end

      it 'deep clones free cells' do
        @g1.free_cells.object_id.should_not == @g2.free_cells.object_id
        @g1.free_cells.zip(@g2.free_cells) do |f1, f2|
          f1.object_id.should_not == f2.object_id unless f1.nil?
          f1.should == f2
        end
      end

      it 'deep clones foundations' do
        @g1.foundations.object_id.should_not == @g2.foundations.object_id

        g1suits = @g1.foundations.values.flatten.sort
        g2suits = @g2.foundations.values.flatten.sort

        g1suits.zip(g2suits) do |g1s, g2s|
          g1s.object_id.should_not == g2s.object_id
          g1s.should == g2s
        end
      end
    end
  end
end
