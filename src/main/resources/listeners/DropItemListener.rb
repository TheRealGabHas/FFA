# frozen_string_literal: true

java_import org.bukkit.event.Listener
java_import org.bukkit.event.player.PlayerDropItemEvent
java_import org.bukkit.plugin.EventExecutor


class DropItemListener
  include Listener

  def self.executor(plugin)
    EventExecutor.impl do |_method, _listener, event|
      if event.is_a?(PlayerDropItemEvent)
        player = event.get_player

        event.set_cancelled(true)
        player.update_inventory
      end
    end
  end
end