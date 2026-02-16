# frozen_string_literal: true

java_import org.bukkit.event.Listener
java_import org.bukkit.event.block.BlockBreakEvent
java_import org.bukkit.plugin.EventExecutor

java_import Java::net.kyori.adventure.text.Component
java_import Java::net.kyori.adventure.text.format.NamedTextColor
java_import Java::net.kyori.adventure.text.format.TextDecoration


class BlockBreakListener
  include Listener

  def self.executor(plugin)
    EventExecutor.impl do |_method, _listener, event|
      if event.is_a?(BlockBreakEvent)
        player = event.get_player
        block = event.get_block
        message = Component.text("#{player.get_name}")
                    .color(NamedTextColor::GOLD)
                    .append(Component.text(" broke ").color(NamedTextColor::GRAY))
                    .append(Component.text("#{block.get_type} ").color(NamedTextColor::GOLD))
                    .append(Component.text(" (x: #{block.get_x}, y: #{block.get_y}, z: #{block.get_z})").color(NamedTextColor::GRAY))

        player.send_message(message)
      end
    end
  end
end