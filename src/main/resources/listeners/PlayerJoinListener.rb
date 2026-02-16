# frozen_string_literal: true

java_import org.bukkit.event.Listener
java_import org.bukkit.event.player.PlayerJoinEvent
java_import org.bukkit.plugin.EventExecutor
java_import org.bukkit.inventory.ItemStack
java_import org.bukkit.Material

java_import Java::net.kyori.adventure.text.Component
java_import Java::net.kyori.adventure.text.format.NamedTextColor
java_import Java::net.kyori.adventure.text.format.TextDecoration


class PlayerJoinListener
  include Listener

  def self.executor(plugin)
    EventExecutor.impl do |_method, _listener, event|
      if event.is_a?(PlayerJoinEvent)
        player = event.get_player
        message =
          Component.text("[FFA] ")
            .color(NamedTextColor::AQUA)
            .append(Component.text("Welcome, ").color(NamedTextColor::GRAY))
            .append(Component.text(player.get_name).color(NamedTextColor::WHITE).decorate(TextDecoration::BOLD))

        player.send_message(message)
      end
    end
  end
end