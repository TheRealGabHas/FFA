# frozen_string_literal: true

java_import org.bukkit.Bukkit
java_import org.bukkit.event.Listener
java_import org.bukkit.plugin.EventExecutor
java_import org.bukkit.event.player.PlayerInteractEvent
java_import org.bukkit.entity.Player
java_import org.bukkit.event.block.Action
java_import org.bukkit.block.Block
java_import org.bukkit.Material

# ACACIA_TRAPDOOR(-1, TrapDoor.class),
#                     644 BAMBOO_TRAPDOOR(-1, TrapDoor.class),
#                     671 BIRCH_TRAPDOOR(-1, TrapDoor.class),
#                     774 CHERRY_TRAPDOOR(-1, TrapDoor.class),
#                     818 COPPER_TRAPDOOR(-1, TrapDoor.class),
#                     845 CRIMSON_TRAPDOOR(-1, TrapDoor.class),
#                     885 DARK_OAK_TRAPDOOR(-1, TrapDoor.class),
#                     966 EXPOSED_COPPER_TRAPDOOR(-1, TrapDoor.class),
#                     1050 IRON_TRAPDOOR(-1, TrapDoor.class),
#                     1067 JUNGLE_TRAPDOOR(-1, TrapDoor.class),
#                     1163 MANGROVE_TRAPDOOR(-1, TrapDoor.class),
#                     1216 OAK_TRAPDOOR(-1, TrapDoor.class),
#                     1245 OXIDIZED_COPPER_TRAPDOOR(-1, TrapDoor.class),
#                     1267 PALE_OAK_TRAPDOOR(-1, TrapDoor.class),
#                     1513 SPRUCE_TRAPDOOR(-1, TrapDoor.class),
#                     1609 WARPED_TRAPDOOR(-1, TrapDoor.class),
#                     1620 WAXED_COPPER_TRAPDOOR(-1, TrapDoor.class),
#                     1629 WAXED_EXPOSED_COPPER_TRAPDOOR(-1, TrapDoor.class),
#                     1638 WAXED_OXIDIZED_COPPER_TRAPDOOR(-1, TrapDoor.class),
#                     1647 WAXED_WEATHERED_COPPER_TRAPDOOR(-1, TrapDoor.class),
#                     1656 WEATHERED_COPPER_TRAPDOOR(-1, TrapDoor.class),
#                     2036 LEGACY_IRON_TRAPDOOR(167, org.bukkit.material.TrapDoor.class)

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