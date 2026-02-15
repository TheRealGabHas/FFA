# frozen_string_literal: true

java_import 'org.bukkit.event.Listener'
java_import 'org.bukkit.event.player.PlayerJoinEvent'
java_import 'org.bukkit.plugin.EventExecutor'
java_import 'org.bukkit.inventory.ItemStack'
java_import 'org.bukkit.Material'

class PlayerJoinListener
  include Listener

  def self.executor(plugin)
    EventExecutor.impl do |_method, _listener, event|
      if event.is_a?(PlayerJoinEvent)
        player = event.get_player
        player.send_message("§b[FFA] §7Welcome, §f#{player.get_name}!")
        player.get_inventory.add_item(ItemStack.new(Material::DIAMOND))
      end
    end
  end
end