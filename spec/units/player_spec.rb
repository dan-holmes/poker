describe Player do
    it "has a name and stack value" do
        player = Player.new('Dan', 1000)
        expect(player.name).to eq 'Dan'
        expect(player.stack).to eq 1000
    end

    describe "#deposit" do
        it "adds more chips" do
            player = Player.new('Dan', 1000)
            player.deposit(1000)
            expect(player.stack).to eq 2000
        end
    end

    describe " #debit" do
        it "Subtracts from player's stack" do
            player = Player.new('Dan', 1000)
            player.debit(500)
            expect(player.stack).to eq 500
        end
        it "errors if player does not have enough chips" do
            player = Player.new('Dan', 1000)
            expect{ player.debit(2000) }.to raise_error "Not enough chips."
        end
    end
end