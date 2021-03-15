class Poker < Sinatra::Base
    enable :sessions
    session_secret
    set :session_secret, "here be dragons"
    
    configure do
        enable :cross_origin
    end

    before do
        response.headers['Access-Control-Allow-Origin'] = '*'
    end

    get '/round' do
        content_type :json
        data = { 
            pot: Game.round.pot,
            current_bet: Game.round.current_bet,
            player_to_bet: Game.round.player_to_bet.name,
            community_cards: Game.round.community_cards.map{ |card| card.json },
            hands: Game.round.hands.map{ |player, hand| {player: player.name, cards: hand.cards.map{ |card| card.json }}},
            winner: Game.round.get_winner
            }
        data.to_json
    end

    get '/round/new' do
        @round = Round.new(@players, @deck)
    end

    post '/bets' do
        player = Game.get_player(params[:player_name])
        amount = params[:amount].to_i
        Game.round.bet(player, amount)
        201
    end
end