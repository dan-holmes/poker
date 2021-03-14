class ScoreCalculator
    def self.score(cards)
        if self.flush(cards)
            return self.score_high_card_values(self.values(cards)) * 14**(9 - 4)
        elsif self.straight(cards)
            return self.straight(cards) * 14**8
        elsif self.three_of_a_kind(cards)
            return self.three_of_a_kind(cards) * 14**7 + self.score_high_card_values(self.single_cards(cards))
        elsif self.two_pair(cards)
            return self.two_pair(cards)[0] * 14**6 + self.two_pair(cards)[1] * 14**5 + self.score_high_card_values(self.single_cards(cards))
        elsif self.pair(cards)
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
        self.count_of_each_card(cards).select { |value, count| count == 2 }.keys.first
    end

    def self.two_pair(cards)
        pair_values = self.count_of_each_card(cards).select { |value, count| count == 2}.keys
        pair_values.length == 2 ? pair_values.sort!.reverse! : false
    end

    def self.three_of_a_kind(cards)
        self.count_of_each_card(cards).select { |value, count| count == 3 }.keys.first
    end

    def self.straight(cards)
        sorted_values = values(cards).sort
        unique = sorted_values.uniq == sorted_values
        span_five = sorted_values.last - sorted_values.first == 4
        unique && span_five ? sorted_values.last : false
    end

    def self.flush(cards)
        cards.map { |card| card.suit }.uniq.length == 1
    end

    def self.single_cards(cards)
        self.count_of_each_card(cards).select {|card, count| count == 1 }.keys
    end

    def self.values(cards)
        return cards.map{ |card| card.value }
    end
end