require 'spec_helper'

module FreeCell
  describe Problem do
    let(:goal) { State.generate_goal_state }
    subject(:pr) { Problem.new(state, goal) }

    describe '#solved?' do
      context 'with a goal state' do
        let(:state) { State.generate_goal_state }
        specify { pr.solved?.should be_true }
      end

      context 'without a goal state' do
        let(:state) {
          s = State.generate_goal_state
          s.free_cells[0] = s.foundations[:spades].pop
          s
        }
        specify { pr.solved?.should be_false }
      end
    end

    describe '#actions' do
      context 'when an AH is in a free cell' do
        let(:state) {
          s = State.generate_goal_state
          s.foundations[:hearts] = []
          s.free_cells[0] = Card.from_string('AH')
          s
        }

        it 'suggests moving to a foundation' do
          pr.actions.map { |m| m.key }.should include "Fr[AH]->Fo[H]"
        end
      end

      context 'when a JH is in a free cell but no foundations to insert into' do
        let(:state) {
          s = State.generate_goal_state
          s.foundations[:hearts] = []
          s.free_cells[0] = Card.from_string('JH')
          s
        }

        it 'does not suggest moving to a foundation' do
          pr.actions.map { |a| a.key }.should_not include "Fr[JH]->Fo[H]"
        end
      end

      context 'when the board only contains an ace' do
        let(:ace) { FreeCell::Card.new('A', :hearts) }
        let(:state) {
          State.generate_goal_state.tap { |s|
            s.columns = [ [Card.from_string('AH')] ]
            s.foundations[:hearts] = []
          }
        }

        it 'moves the ace to the foundation' do
          pr.actions.map { |a| a.key }.should include "Col[AH]->Fo[H]"
        end
      end

      context 'when the board only contains a TH' do
        let(:state) {
          State.generate_goal_state.tap { |s|
            s.columns = [ [Card.from_string('TH')] ]
          }
        }

        it 'moves the TH to the free cell' do
          pr.actions.map { |a| a.key }.should include "Col[TH]->Fr[0]"
        end
      end

      context 'when the board contains a JC and a TD' do
        let(:state) {
          State.generate_goal_state.tap { |s|
            s.columns = [ [Card.from_string('JC')], [Card.from_string('TD')] ]
            s.foundations[:clubs] = []
            s.foundations[:diamonds] = []
            s.free_cells = []
          }
        }

        it 'moves the TD on top of the JC' do
          pr.actions.map { |a| a.key }.should include "Col[TD]->Col[JC]"
        end
      end

      context 'when the board contains 2H, a blank, 3S' do
        let(:state) {
          State.generate_goal_state(:num_cards => 2).tap { |s|
            s.columns = [[], [Card.from_string('3S')], [Card.from_string('2H')]]
            s.foundations.each { |k, v| s.foundations[k] = [] }
            s.free_cells = []
          }
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

      context 'when the board has 3S and 3C, and 2H is in a free cell,', :focus => true do
        let(:state) {
          State.generate_goal_state(:num_suits => 4).tap { |s|
            s.columns = [[Card.from_string('3S')], [Card.from_string('3C')]]
            s.foundations.each { |k, v| s.foundations[k] = [] }
            s.free_cells[0] = Card.from_string('2H')
          }
        }

        it 'suggests moving the 2H on top of 3S' do
          pr.actions.map { |a| a.key }.should include "Fr[2H]->Col[3S]"
        end

        it 'suggests moving the 2H on top of 3C' do
          pr.actions.map { |a| a.key }.should include "Fr[2H]->Col[3C]"
        end
      end
    end
  end
end
