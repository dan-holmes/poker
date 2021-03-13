describe Deck do
    before(:each) do
        cards = [double(:card1), double(:card2), double(:card3), double(:card4)]
        @deck = Deck.new(cards)
    end
    describe '#shuffle' do
        it "shuffles the order of the cards" do
            expect(@deck.cards) .to receive(:shuffle!)
            @deck.shuffle
        end
    end
end