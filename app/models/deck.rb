class Deck
    attr_reader :cards

    def initialize(cards = generate_cards)
        @cards = cards
    end

    def shuffle
        @cards.shuffle!
    end

    def generate_cards
        cards = []
        for suit in ['hearts', 'diamonds', 'spades', 'clubs'] do
            for value in 1..13 do
                cards.push(Card.new(suit, value))
            end
        end
        return cards
    end
end