class Round
    attr_reader :hands, :pot

    def initialize(players)
        @hands = deal_hands(players)
        @pot = 0
    end

    def deal_hands(players)
        hands = []
        for player in players do
            cards = [Card.new('hearts', 1), Card.new('spades', 1)]
            hands.push(Hand.new(cards, player))
        end
        return hands
    end
end