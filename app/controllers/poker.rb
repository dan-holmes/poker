class Poker < Sinatra::Base
    enable :sessions
    session_secret
    set :session_secret, "here be dragons"

    get '/' do
        "Hello, world!"
    end
end