# frozen_string_literal: true

java_import org.bukkit.event.Listener
java_import com.destroystokyo.paper.event.player.PlayerPostRespawnEvent
java_import org.bukkit.plugin.EventExecutor

java_import Java::net.kyori.adventure.text.Component
java_import Java::net.kyori.adventure.text.format.NamedTextColor


class PlayerPostRespawnListener
  include Listener

  def self.handle_post_respawn(event)
    player = event.get_player
    # Reequip the current kit so it resets (potion effect, amount of food...)
    # If the player never selected a kit/ has an invalid one → equip kit #1
    current_kit = Score.get_player_score(player, Score::CURRENT_KIT)
    unless Kits::VALID_KIT_IDS.include?(current_kit)
      current_kit = Kits::VALID_KIT_IDS[0]
      info_message = Component.text("[gFFA] ").color(NamedTextColor::YELLOW)
                              .append(Component.text("You died with no kit, so you received the kit ").color(NamedTextColor::GRAY))
                              .append(Component.text(current_kit).color(NamedTextColor::AQUA))
      player.send_message(info_message)
    end
    Kits.equip_selected_kit(index: current_kit, player: player, show_message: false)
  end

  def self.executor(plugin)
    EventExecutor.impl do |_method, _listener, event|
      if event.is_a?(PlayerPostRespawnEvent)
        self.handle_post_respawn(event)
      end
    end
  end

end