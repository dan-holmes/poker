class Game
    def self.start
        @player1 = Player.new('Dan', 1000)
        @player2 = Player.new('Emma', 1000)
        @player3 = Player.new('Josh', 1000)
        @player4 = Player.new('Jack', 1000)
        @players = [@player1, @player2, @player3, @player4]
        @deck = Deck.new
        @round = Round.new(@players, @deck)
    end

    def self.round
        @round
    end

    def self.get_player(name)
        @players.select{ |player| player.name == name }.first
    end
end