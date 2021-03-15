describe Hand do
    describe "#initialize" do
        it "calls deck.deal_card twice to add 2 cards" do
            deck = double(:deck)
            expect(deck).to receive(:deal_card).exactly(2).times
            hand = Hand.new(deck, double(:score_calculator))
            expect(hand.cards.length).to eq 2
        end
    end
    describe "#score" do
        it "gets the best available score for 5 of the 7 cards" do
            deck = double(:deck)
            hc1 = double(:card)
            hc2 = double(:card)
            score_calculator = double(:score_calculator)

            allow(deck).to receive(:deal_card).and_return(hc1, hc2)
            @hand = Hand.new(deck, score_calculator)

            cc1 = double(:card)
            cc2 = double(:card)
            cc3 = double(:card)
            cc4 = double(:card)
            cc5 = double(:card)

            community_cards = [cc1, cc2, cc3, cc4, cc5]

            allow(score_calculator).to receive(:score).and_return(0)
            allow(score_calculator).to receive(:score).with([hc1, hc2, cc1, cc2, cc3]).and_return(15)
            allow(score_calculator).to receive(:score).with([hc1, hc2, cc3, cc4, cc5]).and_return(10)
            allow(score_calculator).to receive(:score).with([hc1, cc1, cc3, cc4, cc5]).and_return(20)

            expect(@hand.score(community_cards)).to eq 20
        end
    end
end