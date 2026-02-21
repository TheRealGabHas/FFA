# frozen_string_literal: true

java_import org.bukkit.Bukkit
java_import org.bukkit.event.Listener
java_import org.bukkit.plugin.EventExecutor
java_import org.bukkit.event.entity.PlayerDeathEvent
java_import org.bukkit.entity.Player

java_import Java::net.kyori.adventure.text.Component
java_import Java::net.kyori.adventure.text.format.NamedTextColor


class PlayerDeathListener
  include Listener

  def self.handle_death(event)
    dead_player = event.get_player
    killer_player = dead_player.get_killer
    death_message = Component.text("[gFFA] ").color(NamedTextColor::YELLOW)

    if killer_player != nil && killer_player.is_a?(Player)
      death_message = death_message.append(Component.text(dead_player.get_name).color(NamedTextColor::RED))
                                   .append(Component.text(" was slain by ").color(NamedTextColor::GRAY))
                                   .append(Component.text(killer_player.get_name).color(NamedTextColor::RED))

      # + 1 since the kill is registered in scoreboard after this event
      killer_killstreak = Score.get_player_score(killer_player, Score::STREAK_KILL_COUNT) + 1
      if killer_killstreak > 4 && killer_killstreak % 5 == 0
        killstreak_message = Component.text("[gFFA] ").color(NamedTextColor::YELLOW)
                                      .append(Component.text(killer_player.get_name).color(NamedTextColor::RED))
                                      .append(Component.text(" is on a killstreak of ").color(NamedTextColor::GRAY))
                                      .append(Component.text(killer_killstreak).color(NamedTextColor::RED))
        Bukkit.broadcast(killstreak_message)
      end

      Utils.apply_kill_reward(killer_player)
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
    DataStore.end_combat(dead_player)

    # Reseting the killstreak
    killstreak = Score.get_player_score(dead_player, Score::STREAK_KILL_COUNT)
    if killstreak > 0
      dead_player.send_message(Component.text("[gFFA] ").color(NamedTextColor::YELLOW)
                                        .append(Component.text("You reached a killstreak of ").color(NamedTextColor::GRAY))
                                        .append(Component.text(killstreak).color(NamedTextColor::AQUA)))
      # Register a new best killstreak
      if killstreak > Score.get_player_score(dead_player, Score::BEST_KILLSTREAK)
        Score.set_player_score(dead_player, Score::BEST_KILLSTREAK, killstreak)
      end
    end
    Score.set_player_score(dead_player, Score::STREAK_KILL_COUNT, 0)
  end

  def self.executor(plugin)
    EventExecutor.impl do |_method, _listener, event|
      if event.is_a?(PlayerDeathEvent)
        self.handle_death(event)
      end
    end
  end
end