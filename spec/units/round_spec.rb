describe Round do
    before(:each) do
        @player1 = double(:player, debit: nil, deposit: nil, name: 'Alice', stack: 1000)
        @player2 = double(:player, debit: nil, deposit: nil, name: 'Bob', stack: 1000)
        @player3 = double(:player, debit: nil, deposit: nil, name: 'Charlie', stack: 1000)
        @player4 = double(:player, debit: nil, deposit: nil, name: 'Dan', stack: 1000)
        @players = [@player1, @player2, @player3, @player4]
        @deck = double(:deck, {reset: nil, shuffle: nil, deal_card: double(:card, value: 10, suit: 'Hearts')})
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
            hand_class = double(:hand_class, {new: double(:hand)})
            round = Round.new(@players, @deck, hand_class)
            expect(round.hands.values.length).to eq @players.length
        end
    end

    describe "#deal_community" do
        it "calls deck.deal_card" do
            round = Round.new(@players, @deck)
            expect(@deck).to receive(:deal_card).exactly(1).times
            round.deal_community
        end

        it "adds one community card" do
            round = Round.new(@players, @deck)
            expect{ round.deal_community }.to change{ round.community_cards.length }.by(1)
        end
    end

    describe "#deal_flop" do
        it "calls deck.deal_card three times" do
            round = Round.new(@players, @deck)
            expect(@deck).to receive(:deal_card).exactly(3).times
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
            hand1 = double(:hand, {score: 10})
            hand2 = double(:hand, {score: 20})
            hand3 = double(:hand, {score: 15})
            hand4 = double(:hand, {score: 5})
            hands = {@player1 => hand1, @player2 => hand2, @player3 => hand3, @player4 => hand4}

            round = Round.new(@players, @deck)
            round.deal_flop
            round.deal_community
            round.deal_community

            allow(round).to receive(:hands).and_return(hands)
            allow(round).to receive(:completed).and_return(true)

            expect(round.get_winner).to eq @player2
        end
        it "will not count folded hands" do
            hand1 = double(:hand, {score: 10})
            hand2 = double(:hand, {score: 20})
            hand3 = double(:hand, {score: 15})
            hand4 = double(:hand, {score: 5})
            hands = {@player1 => hand1, @player2 => hand2, @player3 => hand3, @player4 => hand4}
            folded = {@player1 => false, @player2 => true, @player3 => false, @player4 => false}

            round = Round.new(@players, @deck)
            round.deal_flop
            round.deal_community
            round.deal_community

            allow(round).to receive(:hands).and_return(hands)
            allow(round).to receive(:folded).and_return(folded)
            allow(round).to receive(:completed).and_return(true)

            expect(round.get_winner).to eq @player3
        end
        it "returns false if the round isn't over" do
            round = Round.new(@players, @deck)
            expect(round.get_winner).to eq false
        end
    end

    describe " #bet" do
        it "increases the pot" do
            round = Round.new(@players, @deck)
            expect {round.bet(@player3, 100)}.to change{ round.pot }.by(100)
        end
        it "debits the amount from the player's stack" do
            round = Round.new(@players, @deck)
            expect(@player3).to receive(:debit).with(100)
            round.bet(@player3, 100)
        end
        it "increases the current bet to that amount" do
            round = Round.new(@players, @deck)
            round.bet(@player3, 100)
            expect(round.current_bet).to eq 100
        end
        it "errors if bet is too low" do
            round = Round.new(@players, @deck)
            round.bet(@player3, 100)
            expect{ round.bet(@player4, 50) }.to raise_error "Bet too low."
        end
        it "moves onto the next turn" do
            round = Round.new(@players, @deck)
            expect{round.bet(@player3, 100)}.to change{ round.turn }.by(1)
        end
        it "errors if not your turn" do
            round = Round.new(@players, @deck)
            round.bet(@player3, 100)
            expect{ round.bet(@player3, 100) }.to raise_error "Play out of turn."
            expect{ round.bet(@player1, 100) }.to raise_error "Play out of turn."
        end
        it "errors if you can't afford the bet" do
            round = Round.new(@players, @deck)
            expect{ round.bet(@player3, 2000) }.to raise_error "Not enough chips."
        end
        it "allows multiple bets in turn" do
            round = Round.new(@players, @deck)
            round.bet(@player3, 100)
            expect{ round.bet(@player4, 100) }.to_not raise_error
        end
        it "moves turn to first player if last player bets" do
            round = Round.new(@players, @deck)
            round.bet(@player3, 100)
            expect{ round.bet(@player4, 100) }.to change{ round.turn }.from(3).to(0)            
        end
        it "can handle folds" do
            round = Round.new(@players, @deck)
            round.bet(@player3, 100)
            round.fold(@player4)
            round.bet(@player1, 90)
            round.bet(@player2, 130)
            round.bet(@player3, 50)
            expect(round).to receive(:increment_stage)
            round.bet(@player1, 50)
        end
        it "moves to the next round if all matched or folded, including the big blind" do
            round = Round.new(@players, @deck)
            round.bet(@player3, 20)
            round.bet(@player4, 20)
            round.bet(@player1, 10)
            expect(round).to receive(:increment_stage)
            round.bet(@player2, 0)
        end
    end
    describe " #all_matched_or_folded" do
        it "Increments stage if all players have matched first bet" do
            round = Round.new(@players, @deck)
            round.bet(@player3, 100)
            round.bet(@player4, 100)
            round.bet(@player1, 90)
            expect(round).to receive(:increment_stage)
            round.bet(@player2, 80)
        end
        it "Doesn't increment stage if somebody has raised and not all have matched" do
            round = Round.new(@players, @deck)
            round.bet(@player3, 100)
            round.bet(@player4, 100)
            round.bet(@player1, 140)
            expect(round).not_to receive(:increment_stage)
            round.bet(@player2, 130)
        end
        it "Increments stage if one player has raised and all have matched" do
            round = Round.new(@players, @deck)
            round.bet(@player3, 100)
            round.bet(@player4, 100)
            round.bet(@player1, 140)
            round.bet(@player2, 130)
            round.bet(@player3, 50)
            expect(round).to receive(:increment_stage)
            round.bet(@player4, 50)
        end
    end
    describe " #increment_stage" do
        it "deals the appropriate community cards" do
            round = Round.new(@players, @deck)
            expect(round).to receive(:deal_flop)
            round.increment_stage
            expect(round).to receive(:deal_community)
            round.increment_stage
            expect(round).to receive(:deal_community)
            round.increment_stage
            expect(round).not_to receive(:deal_community)
            round.increment_stage
        end
        it "resets the turn" do
            round = Round.new(@players, @deck)
            round.bet(@player3, 100)
            round.increment_stage
            expect{round.bet(@player1, 100)}.not_to raise_error
        end
        it "resets the current bet" do
            round = Round.new(@players, @deck)
            round.bet(@player3, 100)
            round.increment_stage
            expect{round.bet(@player1, 50)}.not_to raise_error
        end
        it "allocates winnings after the last stage" do
            round = Round.new(@players, @deck)
            round.increment_stage
            round.increment_stage
            round.increment_stage
            expect(round).to receive(:allocate_winnings)
            round.increment_stage
        end
    end
    describe " #allocate_winnings" do
        it "gives the pot to the winning hand" do
            round = Round.new(@players, @deck)
            allow(round).to receive(:pot).and_return(100)
            allow(round).to receive(:get_winner).and_return(@player1)
            expect(@player1).to receive(:deposit).with(100)
            round.allocate_winnings
        end
    end
    describe "#fold" do
        it "Ends the round if only one player left" do
            round = Round.new(@players, @deck)
            round.fold(@player3)
            round.fold(@player4)
            expect(round).to receive(:allocate_winnings)
            round.fold(@player1)
            expect(round.completed).to eq true
        end
        it "Stops that player getting another turn" do
            round = Round.new(@players, @deck)
            round.fold(@player3)
            round.bet(@player4, 20)
            round.bet(@player1, 40)
            round.bet(@player2, 30)
            expect(round.player_to_bet).to eq @player4
        end
    end
    describe 'Hands to show' do
        it "Shows the hand of the winner" do
            round = Round.new(@players, @deck)
            allow(round).to receive(:completed).and_return(true)
            allow(round).to receive(:winner).and_return(@player2)
            expect(round.show_hand(@player2)).to eq true
        end
        it "Does not show folded hands" do
            round = Round.new(@players, @deck)
            round.fold(@player3)
            allow(round).to receive(:completed).and_return(true)
            expect(round.show_hand(@player3)).to eq false
        end
        it "Shows no hands if the round is not completed" do
            round = Round.new(@players, @deck)
            allow(round).to receive(:completed).and_return(false)
            expect(round.show_hand(@player1)).to eq false
            expect(round.show_hand(@player2)).to eq false
            expect(round.show_hand(@player3)).to eq false
            expect(round.show_hand(@player4)).to eq false
        end
        it "Can handle checks and folds" do
            round = Round.new(@players, @deck)
            round.bet(@player3, 20)
            round.bet(@player4, 20)
            round.bet(@player1, 10)
            round.fold(@player2)

            round.bet(@player1, 20)
            round.bet(@player3, 20)
            round.bet(@player4, 20)

            round.bet(@player1, 0)
            round.bet(@player3, 0)
            round.bet(@player4, 0)

            round.fold(@player1)
            round.bet(@player3, 0)
            round.bet(@player4, 0)

            expect(round.show_hand(@player1)).to eq false
            expect(round.show_hand(@player3)).to eq true
        end
        context 'Final round of betting' do
            before(:each) do
                @hand1 = double(:hand)
                @hand2 = double(:hand)
                @hand3 = double(:hand)
                @hand4 = double(:hand)
                
                @hands = {@player1 => @hand1, @player2 => @hand2, @player3 => @hand3, @player4 => @hand4}
                @round = Round.new(@players, @deck)
                allow(@round).to receive(:hands).and_return(@hands)
                @round.bet(@player3, 20)
                @round.bet(@player4, 20)
                @round.bet(@player1, 10)
                @round.bet(@player2, 0)
    
                @round.bet(@player1, 0)
                @round.bet(@player2, 0)
                @round.bet(@player3, 0)
                @round.bet(@player4, 0)
    
                @round.bet(@player1, 0)
                @round.bet(@player2, 0)
                @round.bet(@player3, 0)
                @round.bet(@player4, 0)

                @round.bet(@player1, 0)
                @round.bet(@player2, 0)
                @round.bet(@player3, 50)
                @round.bet(@player4, 50)
                @round.bet(@player1, 50)
                
            end
            it "Shows only the winner if they instigated the final bet" do
                allow(@hand1).to receive(:score).and_return(15)
                allow(@hand2).to receive(:score).and_return(10)
                allow(@hand3).to receive(:score).and_return(20)
                allow(@hand4).to receive(:score).and_return(5)
                @round.bet(@player2, 50)

                expect(@round.show_hand(@player1)).to eq false
                expect(@round.show_hand(@player2)).to eq false
                expect(@round.show_hand(@player3)).to eq true
                expect(@round.show_hand(@player4)).to eq false
            end
            it "Shows anyone who has been paid to be seen and has a claim to the win" do
                allow(@hand1).to receive(:score).and_return(15)
                allow(@hand2).to receive(:score).and_return(20)
                allow(@hand3).to receive(:score).and_return(10)
                allow(@hand4).to receive(:score).and_return(5)
                @round.bet(@player2, 50)

                expect(@round.show_hand(@player1)).to eq true
                expect(@round.show_hand(@player2)).to eq true
                expect(@round.show_hand(@player3)).to eq true
                expect(@round.show_hand(@player4)).to eq false
            end
    end
    end
end