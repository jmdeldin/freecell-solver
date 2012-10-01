require 'spec_helper'

module FreeCell
  describe BfsSolver do
    let(:goal) { State.generate_goal_state(:num_suits => 2, :num_cards => 2) }
    let(:problem) { Problem.new(state, goal) }
    subject(:solver) { described_class.new(problem) }

    context 'when given a solved puzzle' do
      let(:state) { goal }
      specify { solver.path_length.should == 0}
    end

    context 'when given a deal with only one move to make' do
      let(:state) {
        goal.clone.tap do |s|
          s.columns = [[Card.from_string('2H')], []]
          s.foundations[:hearts] = [Card.from_string('AH')]
        end
      }

      it 'returns a path cost of 1' do
        solver.solution.should_not be_nil
        solver.path_length.should == 1
      end
    end
  end
end
