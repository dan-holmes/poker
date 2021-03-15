describe "Feature tests" do
        it "Can play a whole round" do
        srand 1234
            player1 = Player.new('Dan', 1000)
            player2 = Player.new('Emma', 1000)
            player3 = Player.new('Josh', 1000)
            player4 = Player.new('Jack', 1000)
            players = [player1, player2, player3, player4]
            deck = Deck.new
            round = Round.new(players, deck)

            puts "Hands:"
            for hand in round.hands do puts hand.print end
            round.bet(player1, 100)
            round.bet(player2, 100)
            round.bet(player3, 100)
            round.bet(player4, 100)
            puts "Pot: " + round.pot.to_s

            puts "Community:"
            for card in round.community_cards do puts card.print end
            round.bet(player1, 50)
            round.bet(player2, -1)
            round.bet(player3, 100)
            round.bet(player4, 100)
            round.bet(player1, 50)
            puts "Pot: " + round.pot.to_s

            puts "Community:"
            for card in round.community_cards do puts card.print end
            round.bet(player1, 0)
            round.bet(player3, 0)
            round.bet(player4, 0)
            puts "Pot: " + round.pot.to_s

            puts "Community:"
            for card in round.community_cards do puts card.print end
            round.bet(player1, 200)
            round.bet(player3, 200)
            round.bet(player4, -1)
            puts "Pot: " + round.pot.to_s

            puts "Winner:"
            puts round.get_winner.print
            puts "Players:"
            for player in players do puts player.print end
    end
end