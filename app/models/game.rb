class Game
    def self.start
        @players = []
        @deck = Deck.new
        @round
    end

    def self.add_player(name)
        @players.push(Player.new(name, 1000))
    end

    def self.remove_player(player)
        puts 'removing'
        puts(@players)
        @players.delete(player)
        puts 'removed'
        puts(@players)
    end

    def self.new_round
        @round = Round.new(@players, @deck)
        self.move_dealer
    end

    def self.move_dealer
        @players = @players[1..-1].push(@players[0]) if @players.length > 1
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