describe ScoreCalculator do
    describe " #score" do
        context " for a high card" do
            it "returns points for each card, modified by a multiplier of base 15 depending on their importance" do
                cards = [Card.new('hearts', 5), Card.new('spades', 9), Card.new('hearts', 8), Card.new('spades', 6), Card.new('hearts', 12)]
                expected_score = 12*(15**4) + 9*(15**3) + (8*(15**2)) + (6*(15**1)) + (5*(15**0))
                expect(ScoreCalculator.score(cards)).to eq expected_score
            end
        end
        context " for a pair" do
            it "gives points for the value of the pair times 15^5 as well as points for high cards as above" do
                cards = [Card.new('hearts', 9), Card.new('hearts', 2), Card.new('spades', 9), Card.new('spades', 6), Card.new('hearts', 12)]
                expected_score = 9*(15**5) + (12*(15**2)) + (6*(15**1)) + (2*(15**0))
                expect(ScoreCalculator.score(cards)).to eq expected_score
            end
        end
        context " for two pairs" do
            it "gives points for the first pair times 15^6, second pair 15^5 and high card as usual" do
                cards = [Card.new('hearts', 11), Card.new('hearts', 4), Card.new('spades', 4), Card.new('spades', 12), Card.new('hearts', 11)]
                expected_score = 11*(15**6) + 4*(15**5) + 12*(15**0)
                expect(ScoreCalculator.score(cards)).to eq expected_score
            end
        end
        context " for three of a kind" do
            it "gives points times 15^7 plus high cards as usual" do
                cards = [Card.new('hearts', 11), Card.new('hearts', 4), Card.new('spades', 2), Card.new('spades', 11), Card.new('hearts', 11)]
                expected_score = 11*(15**7) + 4*(15**1) + 2*(15**0)
                expect(ScoreCalculator.score(cards)).to eq expected_score
            end
        end
        context " for straight" do
            it " gives points for the highest card times 15^8" do
                cards = [Card.new('hearts', 11), Card.new('hearts', 9), Card.new('spades', 8), Card.new('spades', 10), Card.new('hearts', 12)]
                expected_score = 12*(15**8)
                expect(ScoreCalculator.score(cards)).to eq expected_score
            end
        end
        context " for a flush" do
            it " gives points for highest card time 15^9 and each card after that times 15^8 etc" do
                cards = [Card.new('hearts', 10), Card.new('hearts', 5), Card.new('hearts', 6), Card.new('hearts', 10), Card.new('hearts', 12)]
                expected_score = 12*(15**9) + 10*(15**8) + 10*(15**7) + 6*(15**6) + 5*(15**5)
                expect(ScoreCalculator.score(cards)).to eq expected_score
            end
        end
        context " for a full house" do
            it "gives points times 15^10 for the three and times 15^9 for the two" do
                cards = [Card.new('hearts', 5), Card.new('spades', 5), Card.new('hearts', 10), Card.new('spades', 10), Card.new('hearts', 5)]
                expected_score = 5*(15**10) + 10*(15**9)
                expect(ScoreCalculator.score(cards)).to eq expected_score
            end
        end
        context " for four of a kind" do
            it "gives points times 15^11 plus high card as usual" do
                cards = [Card.new('hearts', 5), Card.new('spades', 10), Card.new('hearts', 10), Card.new('spades', 10), Card.new('hearts', 10)]
                expected_score = 10*(15**11) + 5*(15**0)
                expect(ScoreCalculator.score(cards)).to eq expected_score
            end
        end
        context " for a straight flush" do
            it "gives points times 15^12 for highest card" do
                cards = [Card.new('hearts', 8), Card.new('hearts', 9), Card.new('hearts', 10), Card.new('hearts', 11), Card.new('hearts', 12)]
                expected_score = 12*(15**12)
                expect(ScoreCalculator.score(cards)).to eq expected_score
            end
        end
        describe " aces" do
            context "pair" do
                it "counts aces as 14" do
                    cards = [Card.new('hearts', 14), Card.new('hearts', 2), Card.new('spades', 14), Card.new('spades', 6), Card.new('hearts', 12)]
                    expected_score = 14*(15**5) + (12*(15**2)) + (6*(15**1)) + (2*(15**0))
                    expect(ScoreCalculator.score(cards)).to eq expected_score
                end
            end
            context "straight" do
                it "can count an ace as 14" do
                    cards = [Card.new('hearts', 11), Card.new('hearts', 13), Card.new('spades', 14), Card.new('spades', 10), Card.new('hearts', 12)]
                    expected_score = 14*(15**8)
                    expect(ScoreCalculator.score(cards)).to eq expected_score
                end
                it "can count an ace as 1" do
                    cards = [Card.new('hearts', 4), Card.new('hearts', 5), Card.new('spades', 14), Card.new('spades', 2), Card.new('hearts', 3)]
                    expected_score = 5*(15**8)
                    expect(ScoreCalculator.score(cards)).to eq expected_score
                end
            end
        end
    end
end