class Card
    attr_reader :suit, :value
    def initialize(suit, value)
        @suit = suit
        @value = value
    end

    def print
        print_value + print_suit
    end

    def print_value
        case value
        when 14
            'A'
        when 13
            'K'
        when 12
            'Q'
        when 11
            'J'
        else
            value.to_s
        end
    end

    def print_suit
        suit[0].upcase
    end

    def json
        {
            suit: print_suit,
            value: print_value
        }
    end

    def self.blank_json
        {
            suit: 'X',
            value: 'X'
        }
    end
end