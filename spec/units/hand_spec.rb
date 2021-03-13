describe Hand do
    before do
        @player = double(:player)
        @cards = [double(:card), double(:card)]
        @hand = Hand.new(@cards, @player)
    end
    it "initializes with two cards" do
        expect(@hand.cards.length).to eq 2
    end
    it "is assigned to a player" do
        expect(@hand.player).to eq @player
    end
end