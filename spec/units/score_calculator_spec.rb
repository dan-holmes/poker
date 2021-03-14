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
        context " for two pairs" do
            it "gives points for the first pair times 14^6, second pair 14^5 and high card as usual" do
                cards = [Card.new('hearts', 11), Card.new('hearts', 4), Card.new('spades', 4), Card.new('spades', 12), Card.new('hearts', 11)]
                expected_score = 11*(14**6) + 4*(14**5) + 12*(14**0)
                expect(ScoreCalculator.score(cards)).to eq expected_score
            end
        end
        context " for three of a kind" do
            it "gives points times 14^7 plus high cards as usual" do
                cards = [Card.new('hearts', 11), Card.new('hearts', 4), Card.new('spades', 2), Card.new('spades', 11), Card.new('hearts', 11)]
                expected_score = 11*(14**7) + 4*(14**1) + 2*(14**0)
                expect(ScoreCalculator.score(cards)).to eq expected_score
            end
        end
        context " for straight" do
            it " gives points for the highest card times 14^8" do
                cards = [Card.new('hearts', 11), Card.new('hearts', 9), Card.new('spades', 8), Card.new('spades', 10), Card.new('hearts', 12)]
                expected_score = 12*(14**8)
                expect(ScoreCalculator.score(cards)).to eq expected_score
            end
        end
        context " for a flush" do
            it " gives points for highest card time 14^9 and each card after that times 14^8 etc" do
                cards = [Card.new('hearts', 10), Card.new('hearts', 5), Card.new('hearts', 6), Card.new('hearts', 10), Card.new('hearts', 12)]
                expected_score = 12*(14**9) + 10*(14**8) + 10*(14**7) + 6*(14**6) + 5*(14**5)
                expect(ScoreCalculator.score(cards)).to eq expected_score
            end
        end
        context " for a full house" do
            it "gives points times 14^10 for the three and times 14^9 for the two" do
                cards = [Card.new('hearts', 5), Card.new('spades', 5), Card.new('hearts', 10), Card.new('spades', 10), Card.new('hearts', 5)]
                expected_score = 5*(14**10) + 10*(14**9)
                expect(ScoreCalculator.score(cards)).to eq expected_score
            end
        end
    end
end