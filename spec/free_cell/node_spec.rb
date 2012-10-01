require 'spec_helper'

module FreeCell
  describe Node do
    describe '#cost' do
      it 'factors in the parent' do
        p = Node.new(Object.new)
        c = Node.new(Object.new)
        c.parent = p

        c.cost.should == 1
      end
    end

    describe '#==' do
      it 'returns true for the same attributes' do
        n1 = Node.new(State.generate_goal_state)
        n2 = Node.new(State.generate_goal_state)
        expect(n1).to eql n2
      end
    end

    describe '#hash' do
      it 'returns the same hash for identical attributes' do
        n1 = Node.new(State.generate_goal_state)
        n2 = Node.new(State.generate_goal_state)
        expect(n1.hash).to eql n2.hash
      end

      it 'returns a different hash for different attributes' do
        n1 = Node.new(State.generate_goal_state)
        n2 = Node.new(State.generate_goal_state)
        n2.parent = Node.new(Object.new)
        expect(n1.hash).to_not eql n2.hash
      end
    end
  end
end
