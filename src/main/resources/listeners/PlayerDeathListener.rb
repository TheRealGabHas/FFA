# frozen_string_literal: true

java_import org.bukkit.Bukkit
java_import org.bukkit.event.Listener
java_import org.bukkit.plugin.EventExecutor
java_import org.bukkit.event.entity.PlayerDeathEvent
java_import org.bukkit.entity.Player

java_import Java::net.kyori.adventure.text.Component
java_import Java::net.kyori.adventure.text.format.NamedTextColor
java_import Java::net.kyori.adventure.text.format.TextDecoration


class PlayerDeathListener
  include Listener

  def self.handle_death(event)
    dead_player = event.get_player
    killer_player = dead_player.get_killer
    death_message = Component.text("[gFFA] ").color(NamedTextColor::YELLOW)

    if killer_player != nil && killer_player.method_defined?(:get_name)
      death_message = death_message.append(Component.text(dead_player.get_name).color(NamedTextColor::RED))
                                   .append(Component.text(" was slain by ").color(NamedTextColor::GRAY))
                                   .append(Component.text(killer_player.get_name).color(NamedTextColor::RED))
    else
      death_message = death_message.append(Component.text(dead_player.get_name).color(NamedTextColor::RED))
                                   .append(Component.text(" died").color(NamedTextColor::GRAY))
    end

    event.set_keep_inventory(true)  # Player keeps their stuff
    event.get_drops.clear  # No copy of the stuff is dropped
    event.set_new_exp(0)
    event.set_should_drop_experience(false)
    event.death_message(death_message)

    # Leaving combat and arena (as the player should not respawn IN the arena)
    Score.set_player_score(dead_player, Score::IN_ARENA, 0)
    Score.set_player_score(dead_player, Score::IN_COMBAT, 0)
  end

  def self.executor(plugin)
    EventExecutor.impl do |_method, _listener, event|
      if event.is_a?(PlayerDeathEvent)
        self.handle_death(event)
      end
    end
  end
end