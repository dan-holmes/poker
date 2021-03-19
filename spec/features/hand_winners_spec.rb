describe "Feature tests" do
        it "Can play a whole round" do
            srand 1000
            player1 = Player.new('Dan', 1000)
            player2 = Player.new('Emma', 1000)
            player3 = Player.new('Josh', 1000)
            player4 = Player.new('Jack', 1000)
            players = [player1, player2, player3, player4]
            deck = Deck.new
            round = Round.new(players, deck)

            # puts "Hands:"
            # for player, hand in round.hands do puts player.name + " " + hand.print end
            round.bet(player1, 100)
            round.bet(player2, 100)
            round.bet(player3, 100)
            round.bet(player4, 100)
            # puts "Pot: " + round.pot.to_s
            expect(round.pot).to eq 400

            # puts "Community:"
            # for card in round.community_cards do puts card.print end
            round.bet(player1, 50)
            round.fold(player2)
            round.bet(player3, 100)
            round.bet(player4, 100)
            round.bet(player1, 50)
            # puts "Pot: " + round.pot.to_s
            expect(round.pot).to eq 700

            # puts "Community:"
            # for card in round.community_cards do puts card.print end
            round.bet(player1, 0)
            round.bet(player3, 0)
            round.bet(player4, 0)
            # puts "Pot: " + round.pot.to_s
            expect(round.pot).to eq 700

            # puts "Community:"
            # for card in round.community_cards do puts card.print end
            round.bet(player1, 200)
            round.bet(player3, 200)
            round.fold(player4)
            # puts "Pot: " + round.pot.to_s
            expect(round.pot).to eq 1100

            # puts "Winner:"
            # puts round.get_winner.print
            # puts "Players:"
            # for player in players do puts player.print end
            

            expect(round.get_winner).to eq player1
            expect(player1.stack).to eq 1700
            expect(player2.stack).to eq 900
            expect(player3.stack).to eq 600
            expect(player4.stack).to eq 800
    end
end