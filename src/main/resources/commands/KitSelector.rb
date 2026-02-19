# frozen_string_literal: true

java_import java.util.ArrayList

java_import org.bukkit.entity.Player
java_import org.bukkit.inventory.InventoryHolder
java_import org.bukkit.inventory.ItemStack
java_import org.bukkit.inventory.meta.ItemMeta
java_import org.bukkit.inventory.ItemFlag
java_import org.bukkit.Material

java_import Java::io.papermc.paper.command.brigadier.BasicCommand

java_import Java::net.kyori.adventure.text.Component
java_import Java::net.kyori.adventure.text.format.NamedTextColor
java_import Java::net.kyori.adventure.text.format.TextDecoration


class KitSelectorInventory
  include InventoryHolder

  def initialize(plugin)
    inv_title = Component.text("Kit Selection").color(NamedTextColor::WHITE)
    @inventory = plugin.get_server.create_inventory(self, 9, inv_title)

    items = [
      ItemBuilder.build_item(material: Material::IRON_SWORD,
                 name: Component.text("1 - Melee").color(NamedTextColor::GREEN).decorate(TextDecoration::BOLD),
                 lore: ArrayList.new([Component.text("+ ").color(NamedTextColor::GREEN).append(Component.text("Sword").color(NamedTextColor::WHITE)).decoration(TextDecoration::ITALIC, false),
                                      Component.text("+ ").color(NamedTextColor::GREEN).append(Component.text("Armor").color(NamedTextColor::WHITE)).decoration(TextDecoration::ITALIC, false),
                                      Component.empty,
                                      Component.text("Click to select").color(NamedTextColor::YELLOW)])),
      ItemBuilder.build_item(material: Material::BOW,
                 name: Component.text("2 - Archer").color(NamedTextColor::GREEN).decorate(TextDecoration::BOLD),
                 lore: ArrayList.new([Component.text("+").color(NamedTextColor::GREEN).append(Component.text(" Bow").color(NamedTextColor::WHITE)).decoration(TextDecoration::ITALIC, false),
                                      Component.text("+").color(NamedTextColor::GREEN).append(Component.text(" Speed").color(NamedTextColor::WHITE)).decoration(TextDecoration::ITALIC, false),
                                      Component.text("-").color(NamedTextColor::RED).append(Component.text(" Armor").color(NamedTextColor::WHITE)).decoration(TextDecoration::ITALIC, false),
                                      Component.empty,
                                      Component.text("Click to select").color(NamedTextColor::YELLOW)])),
      ItemBuilder.build_item(material: Material::FLINT_AND_STEEL,
                 name: Component.text("3 - Pyro").color(NamedTextColor::GREEN).decorate(TextDecoration::BOLD),
                 lore: ArrayList.new([Component.text("+").color(NamedTextColor::GREEN).append(Component.text(" Fire Sword").color(NamedTextColor::WHITE)).decoration(TextDecoration::ITALIC, false),
                                      Component.text("-").color(NamedTextColor::RED).append(Component.text(" Armor").color(NamedTextColor::WHITE)).decoration(TextDecoration::ITALIC, false),
                                      Component.empty,
                                      Component.text("Click to select").color(NamedTextColor::YELLOW)])),
      ItemBuilder.build_item(material: Material::FEATHER,
                             name: Component.text("4 - Ninja").color(NamedTextColor::GREEN).decorate(TextDecoration::BOLD),
                             lore: ArrayList.new([Component.text("+").color(NamedTextColor::GREEN).append(Component.text(" Sword").color(NamedTextColor::WHITE)).decoration(TextDecoration::ITALIC, false),
                                                  Component.text("+").color(NamedTextColor::GREEN).append(Component.text(" Invisibility").color(NamedTextColor::WHITE)).decoration(TextDecoration::ITALIC, false),
                                                  Component.text("-").color(NamedTextColor::RED).append(Component.text(" Armor").color(NamedTextColor::WHITE)).decoration(TextDecoration::ITALIC, false),
                                                  Component.empty,
                                                  Component.text("Click to select").color(NamedTextColor::YELLOW)]))
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
      # If the player is in the arena/ in combat → Not allowed
      # This part of code is duplicated within the `Kits.equip_selected_kit` method to prevent the GUI from even opening
      # when the player is in an unallowed state
      # It's not mandatory to maintain this duplication, I just think it's better UX
      if Score.get_player_score(sender, Score::IN_ARENA) > 0 || Score.get_player_score(sender, Score::IN_COMBAT) > 0
        message = Component.text("[gFFA] ").color(NamedTextColor::YELLOW)
                           .append(Component.text("You can't select a kit while in combat/ arena").color(NamedTextColor::RED))
        sender.send_message(message)
        sender.play_sound(sender.get_location, Sound::BLOCK_NOTE_BLOCK_SNARE, 1.0, 1.0)
        return false
      end

      # No argument provided, open the GUI selection menu
      if args.length < 1
        inv = KitSelectorInventory.new($plugin)
        sender.open_inventory(inv.get_inventory)
        return true
      end

      # Raise an error if the provided argument is not a number
      unless args[0].match?(/\A\d+\z/)
        sender.send_message(Component.text("The first argument must be a number, not a string"))
        return false
      end

      kit_id = args[0].to_i
      # A valid argument (number) was provided, attempt to give the kit
      Kits.equip_selected_kit(index: kit_id, player: sender)
    end
  end

end