class Character
    INITIAL_HEALTH_POINTS = 1000
    INITIAL_LEVEL = 1
    FIGHTER_TYPES = {melee: 2, ranged: 20}
    REDUCTION_FACTOR = 0.5
    MAGNIFICATION_FACTOR = 1.5

    attr_accessor :level, :factions_joined
    attr_reader :health, :range, :position, :factions_joined

    def initialize(type_fighter, position, initial_health = INITIAL_HEALTH_POINTS)
        @health = initial_health
        @alive = true
        @level = INITIAL_LEVEL
        @range = FIGHTER_TYPES[type_fighter]
        @position = position
        @factions_joined = []
    end

    def attack(target, damage)
        if is_a_character?(target) 
	    damage = damage_modifier(target, damage)
            target.receive_damage(damage) if can_receive_damage?(target)
        else
            target.receive_damage(damage)
        end
    end
 
    def heal(target, health_points)
        return unless target.class == self.class

        if target.alive? and (is_an_ally?(target) or am_i_the_target?(target))
            if (target.health + health_points) > INITIAL_HEALTH_POINTS
                health_points = INITIAL_HEALTH_POINTS - target.health
            end
            target.receive_health_points(health_points)
        end
    end
    
    def damage_modifier(target, damage)
	fifty_percent_damage = damage * REDUCTION_FACTOR
	hundred_fifty_percent_damage = damage * MAGNIFICATION_FACTOR

	return fifty_percent_damage if has_five_or_more_levels_above_attacker?(target)
    	return hundred_fifty_percent_damage if has_five_or_more_levels_below_attacker?(target)
	return damage
    end

    def receive_damage(damage)
        @alive = false if damage >= @health
        @health -= damage
    end
    
    def receive_health_points(health_points)
        @health += health_points
    end
        
    def join_factions(factions_to_join)
        factions_to_join.each { |faction| @factions_joined << faction }
    end

    def leave_factions(factions_to_leave)
        factions_to_leave.each { |faction| @factions_joined.delete(faction) }
    end

    def is_an_ally?(other_character)
        allied_faction = @factions_joined.find { |faction| other_character.factions_joined.include?(faction) }    
        allied_faction != nil ? true : false
    end

    def can_receive_damage?(target)
        am_i_the_target?(target) == false and 
        in_range?(target) and
        is_an_ally?(target) == false
    end

    def has_five_or_more_levels_above_attacker?(target)
        @level <= target.level - 5
    end

    def has_five_or_more_levels_below_attacker?(target)
        @level >= target.level + 5
    end

    def in_range?(target)
        (target.position - @position).magnitude <= @range
    end

    def am_i_the_target?(target)
        self == target
    end

    def in_range?(target)
        (target.position - @position).magnitude <= @range
    end

    def is_a_character?(target)
        target.class == Character
    end

    def alive?
        @alive
    end

    public :attack,
           :heal,
           :receive_damage,
           :receive_health_points,
           :join_factions,
           :leave_factions,
           :alive?,
           :is_an_ally? 

    private :in_range?, 
            :am_i_the_target?,
            :in_range?,
            :has_five_or_more_levels_below_attacker?,
            :has_five_or_more_levels_above_attacker?,
            :can_receive_damage?,
	    :damage_modifier,
	    :is_a_character?

end
