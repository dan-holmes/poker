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

    describe '#deal_card' do
        it "Returns the card at the top of the deck" do
            top_card = @deck.cards.last
            expect(@deck.deal_card).to eq top_card
        end
        it "Removes that card from the deck" do
            dealt_card = @deck.deal_card
            expect(@deck.cards).not_to include(dealt_card)
        end
    end
end