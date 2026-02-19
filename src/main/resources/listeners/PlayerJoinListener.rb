# frozen_string_literal: true

java_import org.bukkit.event.Listener
java_import org.bukkit.event.player.PlayerJoinEvent
java_import org.bukkit.plugin.EventExecutor
java_import org.bukkit.inventory.ItemStack
java_import org.bukkit.Material
java_import org.bukkit.Location

java_import Java::net.kyori.adventure.text.Component
java_import Java::net.kyori.adventure.text.format.NamedTextColor
java_import Java::net.kyori.adventure.text.format.TextDecoration


class PlayerJoinListener
  include Listener

  def self.handle_rejoin(player)
    spawn_location = Location.new(player.get_world, 0.5, 1.0, 5.5, 180, 0)

    player.set_respawn_location(spawn_location)  # FIXME: not considered as a safe respawn location
    player.teleport_async(spawn_location)
    player.set_game_mode(GameMode::ADVENTURE)
    Score.set_player_score(player, Score::IN_ARENA, 0)  # Player is no longer in the arena

    player.play_sound(player.get_location, Sound::BLOCK_NOTE_BLOCK_PLING, 1.0, 1.0)

    # If the player disconnected during a combat
    if Score.get_player_score(player, Score::IN_COMBAT) > 0
      warning_message = Component.text("[gFFA] ").color(NamedTextColor::YELLOW)
                                 .append(Component.text("You disconnected during a combat, so you died instead").color(NamedTextColor::RED))

      Score.set_player_score(player, Score::IN_COMBAT, 0)
      player.send_message(warning_message)
      player.play_sound(player.get_location, Sound::BLOCK_NOTE_BLOCK_BELL, 1.0, 1.0)
    end
  end

  def self.executor(plugin)
    EventExecutor.impl do |_method, _listener, event|
      if event.is_a?(PlayerJoinEvent)
        player = event.get_player
        join_message = Component.text("[gFFA] ").color(NamedTextColor::YELLOW)
                                .append(Component.text("Welcome ").color(NamedTextColor::GRAY))
                                .append(Component.text(player.get_name).color(NamedTextColor::WHITE).decorate(TextDecoration::BOLD))
        event.join_message(join_message)
        self.handle_rejoin(player)
      end
    end
  end
end