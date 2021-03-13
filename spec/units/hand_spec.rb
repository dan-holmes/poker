describe Hand do
    before do
        @hand = Hand.new
    end
    it "initializes with two cards" do
        expect(@hand.cards.length).to eq 2
        expect(@hand.cards[0]).to be_a Card
        expect(@hand.cards[1]).to be_a Card
    end
end