class Round
    attr_reader :hands, :pot

    def initialize(players, deck)
        deck.reset
        deck.shuffle
        @players = players
        @hands = []
        @pot = 0
    end

    def deal_hands
        for player in @players do
            cards = [Card.new('hearts', 1), Card.new('spades', 1)]
            @hands.push(Hand.new(cards, player))
        end
    end
end