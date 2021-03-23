require 'jwt'

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

    post '/players' do
        name = params["name"]
        if !Game.players.map{ |player| player.name }.include?(name)
            puts('Adding player ' + name)
            Game.add_player(name)
        end
        content_type :json
        { token: token(name) }.to_json
    end

    post '/leave' do
        token = request.env["HTTP_AUTHORIZATION"].split(' ').last
        decoded_token = JWT.decode(token, nil, false)
        player = Game.get_player(decoded_token[0]["player_name"])
        Game.round.fold(player) if !Game.round.completed
        Game.remove_player(player)
        Game.clear_round if Game.players.empty?
        200
    end

    post '/folds' do
        token = request.env["HTTP_AUTHORIZATION"].split(' ').last
        decoded_token = JWT.decode(token, nil, false)
        player = Game.get_player(decoded_token[0]["player_name"])
        puts(player)
        Game.round.fold(player)
        201
    end

    get '/round' do
        token = request.env["HTTP_AUTHORIZATION"].split(' ').last
        decoded_token = JWT.decode(token, nil, false)
        player = Game.get_player(decoded_token[0]["player_name"])
        content_type :json
        if Game.round
            Game.round.json(player.name)
        else
            {
            round: false,
            hands:
                Game.players.map{ |player|
                    {
                        player: player.json,
                        cards: [],
                        status: 'Not playing'
                    }
                },
            winner: false
            }.to_json
        end
    end

    get '/round/new' do
        Game.new_round
    end

    post '/bets' do
        token = request.env["HTTP_AUTHORIZATION"].split(' ').last
        decoded_token = JWT.decode(token, nil, false)
        player = Game.get_player(decoded_token[0]["player_name"])
        amount = params[:amount].to_i
        begin
            Game.round.bet(player, amount)
        rescue => error
            status 400
        else
            status 201
        end
    end

    def token(player_name)
        JWT.encode( { player_name: player_name } , nil, 'none')
    end

    options "*" do
        response.headers["Allow"] = "GET, PUT, POST, DELETE, OPTIONS"
        response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
        response.headers["Access-Control-Allow-Origin"] = "*"
        200
    end
end