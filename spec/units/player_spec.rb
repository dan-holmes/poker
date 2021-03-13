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
end