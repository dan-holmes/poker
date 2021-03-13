describe ScoreCalculator do
    describe " #score" do
        context " for a high card" do
            it "returns the value of the high card + a decreasing fraction of each subsequent card" do
                cards = [Card.new('hearts', 5), Card.new('spades', 9), Card.new('hearts', 8), Card.new('spades', 6), Card.new('hearts', 12)]
                expected_score = 12 + (9/14) + (8/(14**2)) + (6/(14**3)) + (5/(14**4))
                expect(ScoreCalculator.score(cards)).to eq expected_score
            end
        end
        context " for a pair" do
            it "returns 20 points plus the value of the card, with other high cards processed as above" do
                cards = [Card.new('hearts', 9), Card.new('spades', 9), Card.new('hearts', 8), Card.new('spades', 6), Card.new('hearts', 12)]
                expected_score = 20 + 9 + (12/(14**2)) + (8/(14**3)) + (6/(14**4))
                expect(ScoreCalculator.score(cards)).to eq expected_score
            end
        end
    end
end