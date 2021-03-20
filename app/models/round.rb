class Round
    attr_reader :community_cards, :turn, :bets

    def initialize(players, deck, hand_class = Hand, small_blind = 10)
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
        @completed = false
        @small_blind = small_blind
        deal_hands(hand_class)
        addBlinds
    end

    def deal_hands(hand_class)
        for player in @players do
            @hands[player] = hand_class.new(@deck)
        end
    end

    def addBlinds
        bet(@players[0], @small_blind, true)
        bet(@players[1], @small_blind * 2, true)
    end

    def deal_community
        @community_cards.push(@deck.deal_card)
    end

    def deal_flop
        3.times { deal_community }
    end

    def get_winner
        return false if !completed
        winning_player = unfolded_players.first
        winning_score = hands[winning_player].score(community_cards)
        for player in unfolded_players do
            score = hands[player].score(community_cards)
            if score > winning_score
                winning_player = player
                winning_score = score
            end
        end
        return winning_player
    end

    def get_winner_name
        !!get_winner ? get_winner.name : false
    end

    def unfolded_players
        folded.select{ |player, folded| !folded }.keys
    end

    def bet(player, amount, blind = false)
        raise "Play out of turn." if player_to_bet != player
        raise "Bet too low." if amount + @bets[player] < current_bet
        @pot += amount
        @bets[player] += amount
        player.debit(amount)
        @bet_this_round[player] = true if !blind
        increment_turn
        increment_stage if all_matched_or_folded
    end

    def fold(player)
        raise "Play out of turn." if player_to_bet != player
        @folded[player] = true
        increment_turn
        increment_stage if all_matched_or_folded
        end_round if unfolded_players.length == 1
    end

    def increment_turn
        @turn += 1
        @turn = @turn % @players.length
        increment_turn if @folded[player_to_bet]
    end

    def player_to_bet
        return false if !!get_winner
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
            return false if !(matched && bet_this_round) && !folded
        end
        return true
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
            @completed = true
            allocate_winnings
        end
        @turn = 0
        increment_turn if @folded[player_to_bet]
        @bets = Hash[@players.collect { |player| [player, 0] }]
        @bet_this_round = Hash[@players.collect { |player| [player, false] }]
    end

    def status(player)
        return 'Folded' if @folded[player]
        return 'Small blind' if @bets[player] == @small_blind && !@bet_this_round[player]
        return 'Big blind' if @bets[player] == @small_blind * 2 && !@bet_this_round[player]
        return 'Check' if @bets[player] == 0 && @bet_this_round[player]
        return 'Winner! +' + @pot.to_s if @completed && get_winner_name == player.name
        return 'Loser' if @completed && get_winner_name != player.name
        return 'Bet ' + bet_so_far(player).to_s if @bet_this_round[player]
        return '...'
    end

    def min_raise
        @small_blind
        # This could be changed to match official rules
    end

    def end_round
        @completed = true
        allocate_winnings
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

    def bet_so_far(player)
        @bet_this_round[player] ? @bets[player] : false
    end

    def completed
        @completed
    end

    def json(player_name)
        { 
            round: true,
            pot: @pot,
            current_bet: current_bet,
            player_to_bet: player_to_bet_name,
            min_raise: min_raise,
            community_cards: @community_cards.map{ |card| card.json },
            hands: @hands.map{ |player, hand| {
                player: player.json, 
                cards: hand.cards.map{ |card| 
                    player.name == player_name ? card.json : Card.blank_json
                },
                status: status(player),
                bet_so_far: @bets[player]
            }}
        }.to_json
    end
end