describe ScoreCalculator do
    describe " #score" do
        context " for a high card" do
            it "returns points for each card, modified by a multiplier of base 14 depending on their importance" do
                cards = [Card.new('hearts', 5), Card.new('spades', 9), Card.new('hearts', 8), Card.new('spades', 6), Card.new('hearts', 12)]
                expected_score = 12*(14**4) + 9*(14**3) + (8*(14**2)) + (6*(14**1)) + (5*(14**0))
                expect(ScoreCalculator.score(cards)).to eq expected_score
            end
        end
        context " for a pair" do
            it "gives points for the value of the pair times 14^5 as well as points for high cards as above" do
                cards = [Card.new('hearts', 9), Card.new('hearts', 2), Card.new('spades', 9), Card.new('spades', 6), Card.new('hearts', 12)]
                expected_score = 9*(14**5) + (12*(14**2)) + (6*(14**1)) + (2*(14**0))
                expect(ScoreCalculator.score(cards)).to eq expected_score
            end
        end
    end
end