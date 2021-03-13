class Round
    attr_reader :hands, :pot, :community_cards

    def initialize(players, deck, hands = [])
        @deck = deck
        @deck.reset
        @deck.shuffle
        @players = players
        @hands = hands
        @pot = 0
        @community_cards = []
    end

    def deal_hands(hand_class = Hand)
        for player in @players do
            @hands.push(hand_class.new(player, @deck))
        end
    end

    def deal_community
        @community_cards.push(@deck.deal_card)
    end

    def deal_flop
        3.times { deal_community }
    end

    def get_winner
        winning_hand = @hands.first
        for hand in @hands do
            if hand.score(community_cards) > winning_hand.score(community_cards)
                winning_hand = hand
            end
        end
        return winning_hand.player
    end
end