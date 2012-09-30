require 'spec_helper'

describe Array do
  describe '#index2d' do
    subject(:ary) { [ [:foo, :bar], [:baz, :qux] ] }
    specify { ary.index2d(:foo).should == [0, 0] }
    specify { ary.index2d(:bar).should == [0, 1] }
    specify { ary.index2d(:baz).should == [1, 0] }
    specify { ary.index2d(:qux).should == [1, 1] }
    specify { ary.index2d(:spam).should be_nil }
  end
end
