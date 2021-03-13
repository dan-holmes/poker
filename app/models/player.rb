class Player
    attr_reader :name, :stack

    def initialize(name, initial_stack)
        @name = name
        @stack = initial_stack
    end

    def deposit(chips)
        @stack += chips
    end
end