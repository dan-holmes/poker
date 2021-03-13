describe Round do
    before(:each) do
        @players = [double(:player), double(:player), double(:player), double(:player)]
        @deck = double(:deck, {reset: nil, shuffle: nil})
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

        it "deals unique cards to each player" do
            round = Round.new(@players, @deck)
            round.deal_hands

            dealt_cards = []

            for hand in round.hands do
                dealt_cards.concat(hand.cards)
            end

            expect(dealt_cards.uniq).to eq dealt_cards
        end
    end
end