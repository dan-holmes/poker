class Hand
    attr_reader :cards
    def initialize(deck, score_calculator = ScoreCalculator)
        @cards = []
        2.times{ @cards.push(deck.deal_card) }
        @score_calculator = score_calculator
    end

    def score(community_cards)
        best_score = 0
        all_cards = @cards + community_cards
        for combination in all_cards.combination(5).to_a do
            score = @score_calculator.score(combination)
            if score > best_score
                best_score = score
            end
        end
        return best_score
    end

    def print
        cards[0].print + " " + cards[1].print
    end
end