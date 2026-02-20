# frozen_string_literal: true

java_import org.bukkit.event.Listener
java_import org.bukkit.event.player.PlayerQuitEvent
java_import org.bukkit.plugin.EventExecutor


class PlayerQuitListener
  include Listener

  def self.handle_disconnect(event)

  end

  def self.executor(plugin)
    EventExecutor.impl do |_method, _listener, event|
      if event.is_a?(PlayerQuitEvent)
        leave_message = Component.text("[gFFA] ").color(NamedTextColor::YELLOW)
                                .append(Component.text("- ").color(NamedTextColor::RED))
                                .append(Component.text(event.get_player.get_name).color(NamedTextColor::GRAY))
        event.quit_message(leave_message)
        self.handle_disconnect(event)
      end
    end
  end

end
