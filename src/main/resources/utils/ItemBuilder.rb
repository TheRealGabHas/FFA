# frozen_string_literal: true

java_import java.util.ArrayList

java_import org.bukkit.inventory.ItemStack
java_import org.bukkit.inventory.meta.ItemMeta
java_import org.bukkit.inventory.ItemFlag
java_import org.bukkit.Material
java_import org.bukkit.enchantments.Enchantment


module ItemBuilder

  def self.build_item(material:, name: nil, lore: ArrayList.new([]), unbreakable: false, enchants: [], quantity: 1)
    item = ItemStack.new(material)
    meta = item.get_item_meta

    if name != nil
      meta.item_name(name)  # A custom name has been provided
    end

    meta.lore(lore)
    meta.set_unbreakable(unbreakable)
    meta.add_item_flags(ItemFlag::HIDE_ATTRIBUTES)

    item.set_item_meta(meta)

    enchants.each do |ench, level|
      item.add_enchantment(ench, level)
    end

    item.set_amount(quantity)

    item
  end
end