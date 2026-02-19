# frozen_string_literal: true

java_import org.bukkit.Bukkit
java_import org.bukkit.event.Listener
java_import org.bukkit.event.inventory.InventoryClickEvent
java_import org.bukkit.event.inventory.ClickType
java_import org.bukkit.Sound
java_import org.bukkit.scoreboard.Scoreboard
java_import org.bukkit.scoreboard.ScoreboardManager
java_import org.bukkit.scoreboard.Criteria

java_import Java::net.kyori.adventure.text.Component


class KitInventoryListener
  include Listener

  def self.on_inventory_click(event)
    holder = event.get_inventory.get_holder
    return unless holder.is_a?(KitSelectorInventory)

    event.set_cancelled(true)

    player = event.get_who_clicked
    slot = event.get_raw_slot
    return if slot >= holder.get_inventory.get_size  # Only handle the click in the displayed container, not player's inventory

    Kits.equip_selected_kit(index: slot + 1, player: player)

    event.get_inventory.close
  end

  def self.executor(plugin)
    EventExecutor.impl do |_method, _listener, event|
      if event.is_a?(InventoryClickEvent)
        # Prevent dropping items
        event.set_cancelled(true) if event.get_click == ClickType::DROP || event.get_click == ClickType::CONTROL_DROP

        self.on_inventory_click(event)
      end
    end
  end
end