class ScoreCalculator
    def self.score(cards)
        if self.straight_flush(cards)
            return self.straight_flush(cards) * 15**12
        elsif self.four_of_a_kind(cards)
            return self.four_of_a_kind(cards) * 15**11 + self.score_high_card_values(self.single_cards(cards))
        elsif self.full_house(cards)
            return self.three_of_a_kind(cards) * 15**10 + self.pair(cards) * 15**9
        elsif self.flush(cards)
            return self.score_high_card_values(self.values(cards)) * 15**(9 - 4)
        elsif self.straight(cards)
            return self.straight(cards) * 15**8
        elsif self.three_of_a_kind(cards)
            return self.three_of_a_kind(cards) * 15**7 + self.score_high_card_values(self.single_cards(cards))
        elsif self.two_pair(cards)
            return self.two_pair(cards)[0] * 15**6 + self.two_pair(cards)[1] * 15**5 + self.score_high_card_values(self.single_cards(cards))
        elsif self.pair(cards)
            return self.pair(cards) * 15**5 + self.score_high_card_values(self.single_cards(cards))
        else
            return self.score_high_card_values(self.values(cards))
        end
    end

    def self.score_high_card_values(values)
        values.sort!.reverse!
        modifier = 15**(values.length - 1)
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
        values = values(cards)
        ace_high = values
        ace_low = values.map { |value| value == 14 ? 1 : value }
        self.straight_literal(ace_high) || self.straight_literal(ace_low)
    end

    def self.straight_literal(values)
        unique = values.uniq == values
        span_five = values.max - values.min == 4
        unique && span_five ? values.max : false
    end

    def self.flush(cards)
        cards.map { |card| card.suit }.uniq.length == 1
    end

    def self.full_house(cards)
        trips = self.three_of_a_kind(cards)
        pair = self.pair(cards)
        trips && pair ? [trips, pair] : false
    end

    def self.four_of_a_kind(cards)
        self.count_of_each_card(cards).select { |value, count| count == 4 }.keys.first
    end
    
    def self.straight_flush(cards)
        self.straight(cards) && self.flush(cards) ? self.straight(cards) : false
    end

    def self.single_cards(cards)
        self.count_of_each_card(cards).select {|card, count| count == 1 }.keys
    end

    def self.values(cards)
        return cards.map{ |card| card.value }
    end
end