class Round
    attr_reader :hands, :pot, :community_cards, :turn

    def initialize(players, deck, hands = [])
        @deck = deck
        @deck.reset
        @deck.shuffle
        @players = players
        @hands = hands
        @pot = 0
        @community_cards = []
        @turn = 0
        @bets = Hash[players.collect { |player| [player, 0] }]
        @folded = Hash[players.collect { |player| [player, false] }]
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

    def bet(player, amount)
        raise "Bet too low." if amount < current_bet
        raise "Play out of turn." if player_to_bet != player
        @pot += amount
        @bets[player] = amount
        player.debit(100)
        @turn = (@turn + 1) % @players.length
    end

    def player_to_bet
        @players[turn]
    end

    def current_bet
        @bets.values.max
    end

    def all_matched_or_folded
        for player in @players
            return false if @bets[player] < current_bet && !@folded[player]
        end
        return true
    end
end