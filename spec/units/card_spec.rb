describe Card do
    before(:all) do
        @card = Card.new('hearts', 10)
    end
    it "can return its suit" do
        expect(@card.suit).to eq("hearts")
    end
    it "can return its value" do
        expect(@card.value).to eq(10)
    end
end