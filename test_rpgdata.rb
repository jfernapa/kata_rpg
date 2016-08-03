require "minitest/autorun"
require_relative "character.rb"
require_relative "thing.rb"

class RPGCombat < Minitest::Test

    def setup
        @character = Character.new(:melee, 2)
        @melee_enemy = Character.new(:melee, 3, 800)
        @ranged_enemy = Character.new(:ranged, 10, 800)
    end

    def test_character_starts_alive
        assert_equal true, @character.alive?
    end

    def test_character_starts_at_level_1
        assert_equal 1, @character.level
    end

    def test_character_dies_if_receives_more_damage_than_health
        @melee_enemy.attack(@character, @character.health + 1)
        assert_equal false, @character.alive?
    end
    
    def test_character_can_deal_damage
        enemy_health_before_being_attacked = @melee_enemy.health
        @character.attack(@melee_enemy, 100)
        assert_equal true, @melee_enemy.health < enemy_health_before_being_attacked
    end
    
    def test_character_can_heal
        character = Character.new(:melee, 2, 500)
        character_health_before_being_healed = character.health
        character.heal(character, 200)
        assert_equal true, character.health > character_health_before_being_healed
    end

    def test_character_cannot_heal_because_is_dead
        @melee_enemy.attack(@character, @character.health)
        @character.heal(@character, 200)
        assert_equal true, @character.health == 0
    end
    
    def test_character_cannot_healed_over_his_maximum_health_points
        maximum_health_points = @character.health
        @melee_enemy.attack(@character, 100)
        @character.heal(@character, 200)
        assert_equal true, @character.health == maximum_health_points
    end
    
    def test_character_can_damage_his_enemys
	    enemy_health_points_before_attacked = @melee_enemy.health
	    @character.attack(@melee_enemy, 100)
        assert_equal true, @melee_enemy.health < enemy_health_points_before_attacked
    end

    def test_character_can_damage_himself
	    character_health_before_attacked = @character.health
	    @character.attack(@character, 100)
	    assert_equal true, @character.health == character_health_before_attacked
    end

    def test_character_cant_heal_his_enemys
	    enemy_health_before_healed = @melee_enemy.health
        @character.heal(@melee_enemy, 200)
	    assert_equal true, @melee_enemy.health == enemy_health_before_healed
    end
       
    def test_damage_reduced_50_if_enemy_had_5_levels_above_character
        @melee_enemy.level = 6
        enemy_health_points_before_attacked = @melee_enemy.health
        @character.attack(@melee_enemy, 300)
        damage = 300 * 0.5
        assert_equal true, @melee_enemy.health == enemy_health_points_before_attacked - damage
    end
    
    def test_damage_boosted_50_if_enemy_had_5_levels_below_character
        @character.level = 6
        enemy_health_points_before_attacked = @melee_enemy.health
        @character.attack(@melee_enemy, 300)
        damage = 300 + (300 * 0.5)
        assert_equal true, @melee_enemy.health == enemy_health_points_before_attacked - damage
    end
    
    def test_melee_fighter_has_two_meters_attack_range
        assert_equal true, @character.range <= 2
    end
    
    def test_ranged_fighter_has_twenty_meters_attack_range
        assert_equal true, @character.range <= 20
    end
    
    def test_character_cant_deal_damage_if_enemy_is_not_in_range
        enemy_health_points_before_attacked = @ranged_enemy.health
        damage = 200
        @character.attack(@ranged_enemy, damage)
        assert_equal true, @ranged_enemy.health == enemy_health_points_before_attacked
    end
    
    def test_character_can_deal_damage_if_enemy_is_in_range
        enemy_health_points_before_attacked = @melee_enemy.health
        damage = 200
        @character.attack(@melee_enemy, damage)
        assert_equal true, @melee_enemy.health == enemy_health_points_before_attacked - damage
    end
    
    def test_character_can_join_in_a_faction
        @character.join_factions(["Faction_one"])
        assert_equal true, @character.factions_joined.size == 1
    end
    
    def test_character_can_join_in_various_factions
        @character.join_factions(["Faction_one", "Faction_two"])
        assert_equal true, @character.factions_joined.size > 1
    end
    
    def test_character_can_leave_a_faction
        @character.join_factions(["Faction_one", "Faction_two"])
        @character.leave_factions(["Faction_one"])
        assert_equal ["Faction_two"], @character.factions_joined
    end
    
    def test_character_can_leave_various_factions
        @character.join_factions(["Faction_one", "Faction_two", "Faction_three"])
        @character.leave_factions(["Faction_one", "Faction_two"])
        assert_equal ["Faction_three"], @character.factions_joined
    end
    
    def test_characters_is_an_ally
        character_one = Character.new(:melee, 5)
        character_one.join_factions(["Faction_one"])
        character_two = Character.new(:melee, 7)
        character_two.join_factions(["Faction_one"])
        assert_equal true, character_one.is_an_ally?(character_two)
    end
    
    def test_character_can_not_damage_allies
        @character.join_factions(["Faction_one"])
        ally = Character.new(:melee, 7)
        ally.join_factions(["Faction_one"])
        ally_health_before_attacked = ally.health
        @character.attack(ally, 200)
        assert_equal true, ally.health == ally_health_before_attacked
    end
    
    def test_character_can_heal_allies
        @character.join_factions(["Faction_one"])
        ally = Character.new(:melee, 5, 800)
        ally.join_factions(["Faction_one"])
        ally_health_before_healed = ally.health
        @character.heal(ally, 100)
        assert_equal true, ally.health > ally_health_before_healed
    end
    
    def test_character_can_not_heal_enemys
        @character.join_factions(["Faction_one"])
        @melee_enemy.join_factions(["Faction_two"])
        enemy_health_before_healed = @melee_enemy.health
        @character.heal(@melee_enemy, 100)
        assert_equal true, @melee_enemy.health == enemy_health_before_healed
    end
    
    def test_character_can_not_healed
        house = Thing.new(2000)
        @character.heal(house, 100)
        assert_equal true, house.health == 2000
    end
    
    def test_character_can_deal_damage_other_things_than_characters
        tree = Thing.new(200)
        @character.attack(tree, 50)
        assert_equal true, tree.health == 150
    end
end
