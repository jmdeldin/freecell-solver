require 'spec_helper'

Card = FreeCell::Card

describe Card do
  subject(:card) { described_class.new('A', :hearts) }
  its(:face) { should == 'A' }
  its(:suit) { should == :hearts }
  its(:red?) { should be_true }
  its(:black?) { should be_false }

  describe '#number' do
    {
      'A' => 1,
      'T' => 10,
      'J' => 11,
      'Q' => 12,
      'K' => 13,
      '2' => 2,
      '9' => 9,
    }.each do |face, num|
      specify { Card.new(face, :hearts).value.should == num }
    end
  end

  describe '#<=>' do
    it 'returns 0 if equal' do
      e = Card.new('A', :hearts).<=> Card.new('A', :hearts)
      e.should == 0
    end

    it 'returns 1 if greater than' do
      e = Card.new('2', :hearts).<=> Card.new('A', :hearts)
      e.should == 1
    end

    it 'returns -1 if less than' do
      e = Card.new('A', :hearts).<=> Card.new('2', :hearts)
      e.should == -1
    end
  end

  describe '.from_string' do
    {
      '2H' => ['2', :hearts],
      'TH' => ['T', :hearts],
      'AS' => ['A', :spades],
      'QD' => ['Q', :diamonds],
      'JC' => ['J', :clubs],
    }.each do |str, opts|
      it "handles #{str}" do
        c = Card.from_string(str)
        c.face.should == opts[0]
        c.suit.should == opts[1]
      end
    end

    it 'throws an exception when given an empty string' do
      expect { Card.from_string('') }.to raise_error
    end
  end
end
