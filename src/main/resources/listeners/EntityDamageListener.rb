# frozen_string_literal: true

java_import org.bukkit.event.Listener
java_import org.bukkit.event.entity.EntityDamageEvent
java_import org.bukkit.event.entity.EntityDamageByEntityEvent
java_import org.bukkit.entity.Player
java_import org.bukkit.entity.Projectile
java_import org.bukkit.plugin.EventExecutor


class EntityDamageListener
  include Listener

  def self.handle_entity_damage(event)
    # The logic is: a player falls in the arena (since the spawn is above)
    # so the inArena state is updated on fall damage (and damage are canceled)
    if event.get_entity.is_a?(Player)
      player = event.get_entity
      player_y = player.get_y

      if event.get_cause == EntityDamageEvent::DamageCause::FALL
        # A player is considered in
        # - Arena: -50 <= Y <= -10
        # - Spawn: -9 <= Y <= 20
        if (-50 <= player_y) && (player_y <= -10)
          Score.set_player_score(player, Score::IN_ARENA, 1)
        elsif (-9 <= player_y) && (player_y <= 20)
          Score.set_player_score(player, Score::IN_ARENA, 0)
        end
        event.set_cancelled(true)  # Cancel fall damages
      end

      # Cancel damage if player is not in combat/ arena (meaning they should be in the spawn)
      if Score.get_player_score(player, Score::IN_ARENA) == 0 && Score.get_player_score(player, Score::IN_COMBAT) == 0
        event.set_cancelled(true)
      end
    end
  end

  def self.handle_entity_damage_by_entity(event)
    victim = event.get_entity
    damager = event.get_damager

    if damager.is_a?(Projectile)
      projectile = event.get_damager.copy
      damager = projectile.get_shooter
    end

    # Victim is a player and damaged from outside the arena
    if victim.is_a?(Player) && Score.get_player_score(victim, Score::IN_ARENA) == 0
      event.set_cancelled(true)
      return
    end

    # Damager is outside the arena
    if damager.is_a?(Player) && Score.get_player_score(damager, Score::IN_ARENA) == 0
      event.set_cancelled(true)
      return
    end

    # Player damaged by another player (maybe via a projectile)
    # At this stage it's safe to assume that if both entities are player, they are bot in the arena
    if victim.is_a?(Player) && damager.is_a?(Player)
      $plugin.get_logger.info("#{victim.get_name} has been damaged by #{damager.get_name} (start of combat)")
      DataStore.start_combat(victim)
      DataStore.start_combat(damager)
    else
      $plugin.get_logger.info("#{victim.get_name} has been damaged by #{damager.class} (no combat started)")
    end
  end

  def self.executor(plugin)
    EventExecutor.impl do |_method, _listener, event|
      if event.is_a?(EntityDamageByEntityEvent)
        self.handle_entity_damage_by_entity(event)
      elsif event.is_a?(EntityDamageEvent)
        self.handle_entity_damage(event)
      end
    end
  end
end