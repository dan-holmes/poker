class Game
    def self.start
        @players = []
        @deck = Deck.new
        @round
    end

    def self.add_player(name)
        @players.push(Player.new(name, 1000))
    end

    def self.new_round
        @round = Round.new(@players, @deck)
    end

    def self.round
        @round
    end

    def self.get_player(name)
        @players.select{ |player| player.name == name }.first
    end

    def self.players
        @players
    end
end