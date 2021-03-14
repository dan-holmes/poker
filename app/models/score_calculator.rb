class ScoreCalculator
    def self.score(cards)
        if self.pair(cards)
            return self.pair(cards) * 14**5 + self.score_high_card_values(self.single_cards(cards))
        else
            return self.score_high_card_values(self.values(cards))
        end
    end

    def self.score_high_card_values(values)
        values.sort!.reverse!
        modifier = 14**(values.length - 1)
        modified_value = values.first * modifier
        if values.length == 1
            return modified_value
        else
            return modified_value + self.score_high_card_values(values[1..-1])
        end
    end

    def self.count_of_each_card(cards)
        count_hash = {}
        for card in cards do
            count_hash[card.value] ||= 0
            count_hash[card.value] += 1
        end
        return count_hash
    end

    def self.pair(cards)
        count_hash = self.count_of_each_card(cards)
        for value, count in count_hash
            if count == 2
                return value
            end
        end
        return false
    end

    def self.single_cards(cards)
        self.count_of_each_card(cards).select {|card, count| count == 1 }.keys
    end

    def self.values(cards)
        return cards.map{ |card| card.value }
    end
end