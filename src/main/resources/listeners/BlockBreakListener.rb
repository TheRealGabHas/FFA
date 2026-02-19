# frozen_string_literal: true

java_import org.bukkit.event.Listener
java_import org.bukkit.event.block.BlockBreakEvent
java_import org.bukkit.plugin.EventExecutor
java_import org.bukkit.GameMode


class BlockBreakListener
  include Listener

  def self.executor(plugin)
    EventExecutor.impl do |_method, _listener, event|
      if event.is_a?(BlockBreakEvent)
        if event.get_player.get_game_mode != GameMode::CREATIVE
          event.set_cancelled(true)
        end
      end
    end
  end
end