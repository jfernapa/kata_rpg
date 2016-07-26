class Thing
    attr_reader :health

    def initialize(health)
        @health = health
    end
    
    def receive_damage(damage)
        @health -= damage
    end
end
