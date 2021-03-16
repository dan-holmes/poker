class Poker < Sinatra::Base
    enable :sessions
    session_secret
    set :session_secret, "here be dragons"
    
    set :bind, '0.0.0.0'
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
        Game.new_round
    end

    post '/bets' do
        puts params
        player = Game.get_player(params[:player_name])
        amount = params[:amount].to_i
        Game.round.bet(player, amount)
        201
    end

    options "*" do
        response.headers["Allow"] = "GET, PUT, POST, DELETE, OPTIONS"
        response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
        response.headers["Access-Control-Allow-Origin"] = "*"
        200
    end
end