class Hand
    attr_reader :cards, :player
    def initialize(player = Player.new('Dan', 1000))
        @cards = [Card.new('hearts', 1), Card.new('spades', 1)]
        @player = player
    end
end