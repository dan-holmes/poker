describe Card do
    card = Card.new('hearts', 10)
    it "can return its suit" do
        expect(card.suit).to eq("hearts")
    end
    it "can return its value" do
        expect(card.value).to eq(10)
    end
end