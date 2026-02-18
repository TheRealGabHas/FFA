# frozen_string_literal: true

java_import java.util.ArrayList
java_import org.bukkit.entity.Player
java_import org.bukkit.inventory.ItemStack
java_import org.bukkit.inventory.meta.ItemMeta
java_import org.bukkit.inventory.ItemFlag
java_import org.bukkit.Material
java_import org.bukkit.potion.PotionEffect
java_import org.bukkit.potion.PotionEffectType

java_import Java::net.kyori.adventure.text.Component
java_import Java::net.kyori.adventure.text.format.NamedTextColor
java_import Java::net.kyori.adventure.text.format.TextDecoration

module Kits

  VALID_KIT_IDS = [*(1..4), 999]
  EASTER_EGGS_KIT_IDS = [999]

  def self.equip_selected_kit(index: 1, player:)
    case index
    when 1
      self.equip_melee_kit(player)
    when 2
      self.equip_archer_kit(player)
    when 3
      self.equip_pyro_kit(player)
    when 4
      self.equip_ninja_kit(player)
    else
      self.equip_default_kit(player)
    end
  end

  def self.clear_effects(player)
    player.clear_active_potion_effects
  end

  def self.clear_inventory(player)
    inv = player.get_inventory
    inv.clear
  end

  def self.equip_melee_kit(player)
    helmet      = ItemBuilder.build_item(material: Material::IRON_HELMET, unbreakable: true)
    chestplate  = ItemBuilder.build_item(material: Material::IRON_CHESTPLATE, unbreakable: true)
    leggings    = ItemBuilder.build_item(material: Material::IRON_LEGGINGS, unbreakable: true)
    boots       = ItemBuilder.build_item(material: Material::IRON_BOOTS, unbreakable: true)
    sword       = ItemBuilder.build_item(material: Material::IRON_SWORD, unbreakable: true, enchants: [[Enchantment::SHARPNESS, 1]])
    food        = ItemBuilder.build_item(material: Material::COOKED_BEEF, quantity: 32)

    self.clear_effects(player)
    self.clear_inventory(player)

    inv = player.get_inventory
    inv.set_held_item_slot(0)
    inv.set_item(0, sword)
    inv.set_item(1, food)
    inv.set_helmet(helmet)
    inv.set_chestplate(chestplate)
    inv.set_leggings(leggings)
    inv.set_boots(boots)
  end

  def self.equip_archer_kit(player)
    helmet      = ItemBuilder.build_item(material: Material::IRON_HELMET, unbreakable: true)
    chestplate  = ItemBuilder.build_item(material: Material::CHAINMAIL_CHESTPLATE, unbreakable: true)
    leggings    = ItemBuilder.build_item(material: Material::CHAINMAIL_LEGGINGS, unbreakable: true)
    boots       = ItemBuilder.build_item(material: Material::CHAINMAIL_BOOTS, unbreakable: true)
    sword       = ItemBuilder.build_item(material: Material::WOODEN_SWORD, unbreakable: true, enchants: [[Enchantment::KNOCKBACK, 1]])
    bow         = ItemBuilder.build_item(material: Material::BOW, unbreakable: true, enchants: [[Enchantment::POWER, 2], [Enchantment::INFINITY, 1]])
    arrow       = ItemBuilder.build_item(material: Material::ARROW, quantity: 2)
    food        = ItemBuilder.build_item(material: Material::COOKED_BEEF, quantity: 32)

    self.clear_effects(player)
    self.clear_inventory(player)

    inv = player.get_inventory
    inv.set_held_item_slot(0)
    inv.set_item(0, sword)
    inv.set_item(1, bow)
    inv.set_item(2, food)
    inv.set_item(28, arrow)
    inv.set_helmet(helmet)
    inv.set_chestplate(chestplate)
    inv.set_leggings(leggings)
    inv.set_boots(boots)

    speed_effect = PotionEffect.new(PotionEffectType::SPEED, -1, 0, false, false, true)
    player.add_potion_effect(speed_effect)
  end

  def self.equip_pyro_kit(player)
    helmet      = ItemBuilder.build_item(material: Material::LEATHER_HELMET, unbreakable: true)
    chestplate  = ItemBuilder.build_item(material: Material::IRON_CHESTPLATE, unbreakable: true)
    leggings    = ItemBuilder.build_item(material: Material::LEATHER_LEGGINGS, unbreakable: true)
    boots       = ItemBuilder.build_item(material: Material::IRON_BOOTS, unbreakable: true)
    sword       = ItemBuilder.build_item(material: Material::STONE_SWORD, unbreakable: true, enchants: [[Enchantment::SHARPNESS, 1], [Enchantment::FIRE_ASPECT, 1]])
    food        = ItemBuilder.build_item(material: Material::COOKED_BEEF, quantity: 32)

    self.clear_effects(player)
    self.clear_inventory(player)

    inv = player.get_inventory
    inv.set_held_item_slot(0)
    inv.set_item(0, sword)
    inv.set_item(1, food)
    inv.set_helmet(helmet)
    inv.set_chestplate(chestplate)
    inv.set_leggings(leggings)
    inv.set_boots(boots)

    fire_resistance_effect = PotionEffect.new(PotionEffectType::FIRE_RESISTANCE, -1, 0, false, false, true)
    player.add_potion_effect(fire_resistance_effect)
  end

  def self.equip_ninja_kit(player)
    sword       = ItemBuilder.build_item(material: Material::GOLDEN_SWORD, unbreakable: true, enchants: [[Enchantment::SHARPNESS, 4]])
    food        = ItemBuilder.build_item(material: Material::COOKED_BEEF, quantity: 32)

    self.clear_effects(player)
    self.clear_inventory(player)

    inv = player.get_inventory
    inv.set_held_item_slot(0)
    inv.set_item(1, sword)
    inv.set_item(2, food)

    # Invisibility particles are enabled
    invisibility_effect = PotionEffect.new(PotionEffectType::INVISIBILITY, -1, 0, false, true, true)
    speed_effect = PotionEffect.new(PotionEffectType::SPEED, -1, 1, false, false, true)
    player.add_potion_effect(invisibility_effect)
    player.add_potion_effect(speed_effect)
  end

  def self.equip_default_kit(player)
    # This function shouldn't be reached under normal circumstances
    # This kit may be seen as an "Easter egg"
    egg = ItemBuilder.build_item(material: Material::EGG, quantity: 16, name: Component.text("Easter Egg").color(NamedTextColor::AQUA).decorate(TextDecoration::BOLD))

    self.clear_effects(player)
    self.clear_inventory(player)

    inv = player.get_inventory
    inv.set_held_item_slot(0)
    inv.set_item(0, egg)
  end
end