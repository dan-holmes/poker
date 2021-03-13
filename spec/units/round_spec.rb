describe Round do
    before(:each) do
        @players = [double(:player), double(:player), double(:player), double(:player)]
    end
    it "initialises with 4 hands and a pot of 0" do
        round = Round.new(@players)
        expect(round.hands.length).to eq 4
        expect(round.pot).to eq 0
    end
end