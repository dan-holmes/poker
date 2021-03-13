describe ScoreCalculator do
    describe " #score" do
        context " for a high card" do
            it "returns the value of the high card + a decreasing fraction of each subsequent card" do
                cards = [Card.new('hearts', 5), Card.new('spades', 9), Card.new('hearts', 8), Card.new('spades', 6), Card.new('hearts', 12)]
                expected_score = 12 + (9/13) + (9/(13**2)) + (8/(13**3)) + (6/(13**4)) + (5/(13**5))
                expect(ScoreCalculator.score(cards)).to eq expected_score
            end
        end
    end
end