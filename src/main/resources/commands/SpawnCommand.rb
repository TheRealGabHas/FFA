# frozen_string_literal: true

java_import org.bukkit.entity.Player
java_import org.bukkit.Sound

java_import Java::io.papermc.paper.command.brigadier.BasicCommand
java_import Java::net.kyori.adventure.text.Component
java_import Java::net.kyori.adventure.text.format.NamedTextColor


class SpawnCommand
  include BasicCommand

  def execute(source, args)
    sender = source.get_sender
    executor = source.get_executor

    if sender == executor && sender.is_a?(Player)
      message = Component.text("[gFFA] ").color(NamedTextColor::YELLOW)

      if Score.get_player_score(sender, Score::IN_COMBAT) == 0
        message = message.append(Component.text("You were teleported to the spawn").color(NamedTextColor::GRAY))
        sender.teleport(Location.new(sender.get_world, 0.5, 1.0, 5.5, 180, 0))
        sender.send_message(message)
        sender.play_sound(sender.get_location, Sound::BLOCK_NOTE_BLOCK_PLING, 1.0, 1.0)

        sender.set_health(sender.get_max_health)
        sender.set_food_level(20)

        Score.set_player_score(sender, Score::IN_ARENA, 0)  # Player is no longer in the arena
      else
        message = message.append(Component.text("You can't teleport to spawn while in combat").color(NamedTextColor::RED))
        sender.send_message(message)
        sender.play_sound(sender.get_location, Sound::BLOCK_NOTE_BLOCK_SNARE, 1.0, 1.0)
      end
    end

  end
end