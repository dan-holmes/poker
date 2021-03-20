describe Game do
    it "Moves the dealer each round" do
        Game.start
        Game.add_player('Dan')
        Game.add_player('Jack')
        Game.add_player('Josh')
        Game.new_round
        expect(Game.round.player_to_bet_name).to eq 'Josh'
        Game.new_round
        expect(Game.round.player_to_bet_name).to eq 'Dan'
    end
end