class Hand
    attr_reader :cards
    def initialize
        @cards = [Card.new('hearts', 1), Card.new('spades', 1)]
    end
end