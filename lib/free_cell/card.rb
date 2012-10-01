FreeCell::SuitMap = {
  'H' => :hearts,
  'S' => :spades,
  'D' => :diamonds,
  'C' => :clubs
}

class FreeCell::Card
  attr_reader :face, :suit, :value

  def initialize(face, suit)
    @face = face
    @suit = suit

    @value = case face
              when 'A' then 1
              when 'T' then 10
              when 'J' then 11
              when 'Q' then 12
              when 'K' then 13
              else
                face.to_i
              end
  end

  def red?
    @suit == :hearts || @suit == :diamonds
  end

  def black?
    !red?
  end

  def color
    red?? :red : :black
  end

  def different_color?(other)
    self.color != other.color
  end

  def ==(other)
    return false unless other.class == self.class
    @face == other.face && @suit == other.suit
  end

  # Returns 0 if equal, 1 if greater than other, -1 if less than
  def <=>(other)
    @value.<=>(other.value)
  end

  def hash
    @face.hash ^ @suit.hash
  end

  def to_s
    @face + @suit.to_s.upcase[0].chr
  end

  def ace?
    @face == 'A'
  end

  def sequentially_larger_than?(other)
    @value - other.value == 1
  end

  def self.from_string(str)
    fail "Cannot make card from empty string" if str.to_s.length != 2

    self.new(str[0].chr, FreeCell::SuitMap.fetch(str[1].chr))
  end
end
