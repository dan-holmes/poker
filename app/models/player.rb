class Player
    attr_reader :name, :stack

    def initialize(name, initial_stack)
        @name = name
        @stack = initial_stack
    end

    def deposit(chips)
        @stack += chips
    end

    def debit(chips)
        raise "Not enough chips." if chips > @stack
        @stack -= chips
    end
end