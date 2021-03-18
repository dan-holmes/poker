class Round
    attr_reader :community_cards, :turn

    def initialize(players, deck, hand_class = Hand)
        @deck = deck
        @deck.reset
        @deck.shuffle
        @players = players
        @hands = Hash.new
        @pot = 0
        @community_cards = []
        @turn = 0
        @bets = Hash[players.collect { |player| [player, 0] }]
        @folded = Hash[players.collect { |player| [player, false] }]
        @bet_this_round = Hash[players.collect { |player| [player, false] }]
        @stage = 0
        deal_hands(hand_class)
    end

    def deal_hands(hand_class)
        for player in @players do
            @hands[player] = hand_class.new(@deck)
        end
    end

    def deal_community
        @community_cards.push(@deck.deal_card)
    end

    def deal_flop
        3.times { deal_community }
    end

    def get_winner
        return false if stage < 4
        winning_player = @players.first
        winning_score = hands[winning_player].score(community_cards)
        for player in @players do
            if !folded[player]
                score = hands[player].score(community_cards)
                if score > winning_score
                    winning_player = player
                    winning_score = score
                end
            end
        end
        return winning_player
    end

    def get_winner_name
        !!get_winner ? get_winner.name : false
    end

    def bet(player, amount)
        raise "Play out of turn." if player_to_bet != player
        if amount == -1
            fold(player)
        else
            positive_bet(player, amount)
            @turn += 1
        end
        @bet_this_round[player] = true
        @turn = @turn % @players.length
        return all_matched_or_folded
    end

    def fold(player)
        @folded[player] = true
        @players.delete(player)
    end

    def positive_bet(player, amount)
        raise "Bet too low." if amount + @bets[player] < current_bet
        @pot += amount
        @bets[player] += amount
        player.debit(amount)
    end

    def player_to_bet
        false if !!get_winner
        @players[turn]
    end

    def player_to_bet_name
        !!player_to_bet ? player_to_bet.name : false
    end

    def current_bet
        @bets.values.max
    end

    def all_matched_or_folded
        for player in @players do
            matched = @bets[player] == current_bet
            folded = @folded[player]
            bet_this_round = @bet_this_round[player]
            return false if !(matched || folded) || !bet_this_round
        end
        return increment_stage    
    end

    def increment_stage
        @stage += 1
        case @stage
        when 1
            deal_flop
        when 2
            deal_community
        when 3
            deal_community
        when 4
            allocate_winnings
        end
        @turn = 0
        @bets = Hash[@players.collect { |player| [player, 0] }]
        @bet_this_round = Hash[@players.collect { |player| [player, false] }]
    end

    def allocate_winnings
        winner = get_winner
        winner.deposit(pot)
    end

    def hands
        @hands
    end

    def pot
        @pot
    end

    def stage
        @stage
    end

    def folded
        @folded
    end

    def json(player_name)
        { 
            round: true,
            pot: @pot,
            current_bet: current_bet,
            player_to_bet: player_to_bet_name,
            community_cards: @community_cards.map{ |card| card.json },
            hands: @hands.map{ |player, hand| {
                player: player.json, 
                cards: hand.cards.map{ |card| 
                    player.name == player_name ? card.json : Card.blank_json
                }
            }},
            winner: get_winner_name
            }.to_json
    end
end