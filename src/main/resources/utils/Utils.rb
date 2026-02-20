# frozen_string_literal: true

java_import org.bukkit.entity.Player
java_import org.bukkit.potion.PotionEffect
java_import org.bukkit.potion.PotionEffectType

module Utils
  def self.apply_kill_reward(player)
    # Effect, Duration, Amplifier, Ambient, Show Particles, Show Icon
    regen_effect  = PotionEffect.new(PotionEffectType::REGENERATION, 5*20, 1, false, true, true)
    abso_effect   = PotionEffect.new(PotionEffectType::ABSORPTION, 8*20, 0, false, true, true)
    player.add_potion_effect(regen_effect)
    player.add_potion_effect(abso_effect)
    player.set_food_level(20)
  end
end