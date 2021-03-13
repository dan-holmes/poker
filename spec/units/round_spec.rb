describe Round do
    before(:each) do
        @players = [double(:player), double(:player), double(:player), double(:player)]
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
end