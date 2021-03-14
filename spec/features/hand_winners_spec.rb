require_relative '../spec_helper'

player1 = Player.new('Dan', 1000)
player2 = Player.new('Emma', 1000)
player3 = Player.new('Josh', 1000)
player4 = Player.new('Jack', 1000)
players = [player1, player2, player3, player4]
deck = Deck.new
round = Round.new(players, deck)
round.deal_hands
puts "Hands:"
for hand in round.hands do puts hand.print end
round.deal_flop
round.deal_community
round.deal_community
puts "Community:"
for card in round.community_cards do puts card.print end
puts "Winner:"
puts round.get_winner.name