# frozen_string_literal: true

java_import org.bukkit.entity.Player
java_import org.bukkit.inventory.InventoryHolder
java_import org.bukkit.inventory.ItemStack
java_import org.bukkit.Material
java_import Java::io.papermc.paper.command.brigadier.BasicCommand

java_import Java::net.kyori.adventure.text.Component
java_import Java::net.kyori.adventure.text.format.NamedTextColor


class KitSelectorInventory
  include InventoryHolder

  def initialize(plugin)
    inv_title = Component.text("Kit Selection").color(NamedTextColor::WHITE)
    @inventory = plugin.get_server.create_inventory(self, 9, inv_title)

    items = [
      ItemStack.new(Material::DIAMOND),
      ItemStack.new(Material::GRASS_BLOCK),
      ItemStack.new(Material::NETHER_STAR)
    ]
    items.each_with_index do |item, i|
      @inventory.set_item(i, item)
    end
  end

  def get_inventory
    @inventory
  end

  def getInventory
    self.get_inventory
  end
end


class KitCommand
  include BasicCommand

  def execute(source, args)
    sender = source.get_sender
    executor = source.get_executor

    if sender == executor && sender.is_a?(Player)
      # No argument provided, open the GUI selection menu
      if args.length < 1
        sender.send_message(Component.text("This command can also be used like so: /kit <number>"))
        inv = KitSelectorInventory.new($plugin)
        sender.open_inventory(inv.get_inventory)
        return true
      end

      # Raise an error if the provided argument is not a number
      unless args[0].match?(/\A\d+\z/)
        sender.send_message(Component.text("The first argument must be a number, not a string"))
        return false
      end

      sender.send_message(Component.text("You selected the kit #{args[0].to_i}"))
      true
    end
  end

end