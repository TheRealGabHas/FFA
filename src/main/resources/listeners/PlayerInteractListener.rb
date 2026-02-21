# frozen_string_literal: true

java_import org.bukkit.Bukkit
java_import org.bukkit.event.Listener
java_import org.bukkit.plugin.EventExecutor
java_import org.bukkit.event.player.PlayerInteractEvent
java_import org.bukkit.entity.Player
java_import org.bukkit.event.block.Action
java_import org.bukkit.block.Block
java_import org.bukkit.Material


class PlayerInteractListener
  include Listener

  def self.handle_interaction(event)
    forbidden_blocks = [
      Material::BARREL, Material::CHEST, Material::TRAPPED_CHEST,
      Material::ACACIA_TRAPDOOR, Material::BAMBOO_TRAPDOOR, Material::BIRCH_TRAPDOOR, Material::CHERRY_TRAPDOOR,
      Material::COPPER_TRAPDOOR, Material::CRIMSON_TRAPDOOR, Material::DARK_OAK_TRAPDOOR,
      Material::EXPOSED_COPPER_TRAPDOOR, Material::IRON_TRAPDOOR, Material::JUNGLE_TRAPDOOR, Material::MANGROVE_TRAPDOOR,
      Material::OAK_TRAPDOOR, Material::OXIDIZED_COPPER_TRAPDOOR, Material::PALE_OAK_TRAPDOOR, Material::SPRUCE_TRAPDOOR,
      Material::WARPED_TRAPDOOR, Material::WAXED_COPPER_TRAPDOOR, Material::WAXED_EXPOSED_COPPER_TRAPDOOR,
      Material::WAXED_OXIDIZED_COPPER_TRAPDOOR, Material::WAXED_WEATHERED_COPPER_TRAPDOOR,
      Material::WEATHERED_COPPER_TRAPDOOR, Material::LEGACY_IRON_TRAPDOOR,
      Material::OAK_SIGN,
    ]  # TODO: Add Fence gates and all sign types (and maybe find a better way to include it all)

    if event.get_action == Action::RIGHT_CLICK_BLOCK
      # Player clicked a forbidden block (container, trap...)
      if forbidden_blocks.include?(event.get_clicked_block&.get_type)
        event.set_cancelled(true)
      end
    end
  end

  def self.executor(plugin)
    EventExecutor.impl do |_method, _listener, event|
      if event.is_a?(PlayerInteractEvent)
        self.handle_interaction(event)
      end
    end
  end
end