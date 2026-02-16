# frozen_string_literal: true

java_import org.bukkit.event.Listener
java_import org.bukkit.event.inventory.InventoryClickEvent

java_import Java::net.kyori.adventure.text.Component


class KitInventoryListener
  include Listener

  def self.on_inventory_click(event)
    holder = event.getInventory.get_holder
    return unless holder.is_a?(KitSelectorInventory)

    event.set_cancelled(true)

    player = event.get_who_clicked
    slot = event.get_raw_slot
    return if slot >= holder.get_inventory.get_size  # Only handle the click in the displayed container, not player's inventory

    player.send_message(Component.text("[#{event.get_inventory}] You clicked #{event.get_current_item} (slot #{slot})"))
  end

  def self.executor(plugin)
    EventExecutor.impl do |_method, _listener, event|
      if event.is_a?(InventoryClickEvent)
        self.on_inventory_click(event)
      end
    end
  end
end