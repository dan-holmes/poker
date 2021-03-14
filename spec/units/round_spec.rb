describe Round do
    before(:each) do
        @player1 = double(:player, debit: nil)
        @player2 = double(:player, debit: nil)
        @player3 = double(:player, debit: nil)
        @player4 = double(:player, debit: nil)
        @players = [@player1, @player2, @player3, @player4]
        @deck = double(:deck, {reset: nil, shuffle: nil, deal_card: double(:card)})
    end
    describe "initialize" do
        it "resets deck and shuffles it" do
            expect(@deck).to receive(:reset)
            expect(@deck).to receive(:shuffle)
            round = Round.new(@players, @deck)
        end
    end

    describe "deal_hands" do
        it "create a hand for each player" do
            round = Round.new(@players, @deck)
            hand_class = double(:hand_class, {new: double(:hand)})
            round.deal_hands(hand_class)
            expect(round.hands.length).to eq @players.length
        end
    end

    describe "#deal_community" do
        it "calls deck.deal_card" do
            expect(@deck).to receive(:deal_card).exactly(1).times

            round = Round.new(@players, @deck)
            round.deal_community
        end

        it "adds one community card" do
            round = Round.new(@players, @deck)
            expect{ round.deal_community }.to change{ round.community_cards.length }.by(1)
        end
    end

    describe "#deal_flop" do
        it "calls deck.deal_card three times" do
            expect(@deck).to receive(:deal_card).exactly(3).times

            round = Round.new(@players, @deck)
            round.deal_flop
        end

        it "adds three community cards" do
            round = Round.new(@players, @deck)
            round.deal_flop

            expect(round.community_cards.length).to eq 3
        end
    end

    describe '#get_winner' do
        it "returns the player with the winning hand" do
            player1 = double(:player)
            player2 = double(:player)
            player3 = double(:player)
            hand1 = double(:hand, {score: 10, player: player1})
            hand2 = double(:hand, {score: 20, player: player2})
            hand3 = double(:hand, {score: 15, player: player3})
            hands = [hand1, hand2, hand3]

            round = Round.new(@players, @deck, hands)
            round.deal_flop
            round.deal_community
            round.deal_community

            expect(round.get_winner).to eq player2
        end
    end

    describe " #bet" do
        it "increases the pot" do
            round = Round.new(@players, @deck)
            expect {round.bet(@player1, 100)}.to change{ round.pot }.by(100)
        end
        it "debits the amount from the player's stack" do
            round = Round.new([@player1, double(:player)], @deck)
            expect(@player1).to receive(:debit).with(100)
            round.bet(@player1, 100)
        end
        it "increases the current bet to that amount" do
            round = Round.new(@players, @deck)
            round.bet(@player1, 100)
            expect(round.current_bet).to eq 100
        end
        it "errors if bet is too low" do
            round = Round.new(@players, @deck)
            round.bet(@player1, 100)
            expect{ round.bet(@player2, 50) }.to raise_error "Bet too low."
        end
        it "moves onto the next turn" do
            round = Round.new(@players, @deck)
            expect{round.bet(@player1, 100)}.to change{ round.turn }.by(1)
        end
        it "errors if not your turn" do
            round = Round.new(@players, @deck)
            round.bet(@player1, 100)
            expect{ round.bet(@player1, 100) }.to raise_error "Play out of turn."
            expect{ round.bet(@player3, 100) }.to raise_error "Play out of turn."
        end
        it "allows multiple bets in turn" do
            round = Round.new(@players, @deck)
            round.bet(@player1, 100)
            expect{ round.bet(@player2, 100) }.to_not raise_error
        end
        it "moves turn to first player if last player bets" do
            round = Round.new(@players, @deck)
            round.bet(@player1, 100)
            round.bet(@player2, 100)
            round.bet(@player3, 100)
            expect{ round.bet(@player4, 100) }.to change{ round.turn }.from(3).to(0)
        end
        it "can handle folds" do
            round = Round.new(@players, @deck)
            round.bet(@player1, 100)
            round.bet(@player2, false)
            round.bet(@player3, 100)
            round.bet(@player4, 150)
            round.bet(@player1, 150)
            expect(round.player_to_bet).to eq @player3
            expect(round.all_matched_or_folded).to be false
            round.bet(@player3, 150)
            expect(round.all_matched_or_folded).to be true
        end
        it "moves to the next round if all matched or folded" do
            round = Round.new(@players, @deck)
            round.bet(@player1, 100)
            round.bet(@player2, 100)
            round.bet(@player3, 100)
            expect{ round.bet(@player4, 100) }.to change{ round.stage }.by(1)
        end
    end
    describe " #all_matched_or_folded" do
        it "Is true if all players have matched first bet" do
            round = Round.new(@players, @deck)
            round.bet(@player1, 100)
            round.bet(@player2, 100)
            round.bet(@player3, 100)
            round.bet(@player4, 100)
            expect(round.all_matched_or_folded).to be true
        end
        it "Is false if somebody has raised and not all have matched" do
            round = Round.new(@players, @deck)
            round.bet(@player1, 100)
            round.bet(@player2, 100)
            round.bet(@player3, 150)
            round.bet(@player4, 150)
            expect(round.all_matched_or_folded).to be false
        end
        it "Is true if one player has raised and all have matched" do
            round = Round.new(@players, @deck)
            round.bet(@player1, 100)
            round.bet(@player2, 100)
            round.bet(@player3, 150)
            round.bet(@player4, 150)
            round.bet(@player1, 150)
            round.bet(@player2, 150)
            expect(round.all_matched_or_folded).to be true
        end
    end
end