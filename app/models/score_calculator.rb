class ScoreCalculator
    def self.score(cards)
        # high card
        card_values = cards.map{|card| card.value }
        sorted_card_values = card_values.sort.reverse
        score = 0
        for i in 0..4 do
            modifier = 13**i
            score += sorted_card_values[i] / modifier
        end
        return score
    end
end