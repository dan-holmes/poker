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
        it "puts two cards in each hand" do
            round = Round.new(@players, @deck)
            round.deal_hands
            for hand in round.hands do
                expect(hand.cards.length).to eq 2
            end
        end

        it "calls deck.deal_card twice for each player" do
            expect(@deck).to receive(:deal_card).exactly(@players.length * 2).times

            round = Round.new(@players, @deck)
            round.deal_hands
        end
    end

    # describe "deal_flop" do
    #     it "adds three unique cards to the community cards" do
    #         round = Round.new(@players, @deck)
    #         round.deal_flop

    #         expect(round.community_cards.length).to eq 3
    #         expect(round.community_cards.uniq).to eq round.community_cards
    #     end
    # end
end