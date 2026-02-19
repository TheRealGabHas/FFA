# frozen_string_literal: true

java_import org.bukkit.Bukkit
java_import org.bukkit.event.Listener
java_import org.bukkit.event.player.PlayerJoinEvent
java_import org.bukkit.event.player.PlayerDropItemEvent
java_import org.bukkit.event.inventory.InventoryClickEvent
java_import org.bukkit.event.entity.EntityDamageEvent
java_import org.bukkit.event.entity.PlayerDeathEvent
java_import org.bukkit.plugin.EventExecutor
java_import org.bukkit.GameRule

java_import Java::io.papermc.paper.plugin.lifecycle.event.types.LifecycleEvents


def load_ruby_file(path)
  start = Time.now
  stream = $plugin.get_resource(path)
  if stream.nil?
    $plugin.get_logger.severe("Failed to find resource: #{path}")
    return
  end

  content_bytes = stream.read_all_bytes
  stream.close

  eval(String.from_java_bytes(content_bytes))
  $plugin.get_logger.info("Loaded #{path} in #{Time.now - start}s (#{content_bytes.length} bytes)")
end

FILES = %w[utils/Scores.rb utils/ItemBuilder.rb utils/Kits.rb
          listeners/PlayerJoinListener.rb listeners/BlockBreakListener.rb
          commands/KitSelector.rb commands/SpawnCommand.rb
          listeners/KitInventoryListener.rb listeners/DropItemListener.rb
          listeners/EntityDamageListener.rb listeners/PlayerDeathListener.rb]
FILES.each { |path| load_ruby_file(path) }


# Registering the event manually (Event class, Listener instance, Priority, Executor, Plugin)
Bukkit.get_plugin_manager.register_event(PlayerJoinEvent.java_class, PlayerJoinListener.new, org.bukkit.event.EventPriority::NORMAL, PlayerJoinListener.executor($plugin), $plugin)
Bukkit.get_plugin_manager.register_event(BlockBreakEvent.java_class, BlockBreakListener.new, org.bukkit.event.EventPriority::NORMAL, BlockBreakListener.executor($plugin), $plugin)
Bukkit.get_plugin_manager.register_event(InventoryClickEvent.java_class, KitInventoryListener.new, org.bukkit.event.EventPriority::NORMAL, KitInventoryListener.executor($plugin), $plugin)
Bukkit.get_plugin_manager.register_event(PlayerDropItemEvent.java_class, DropItemListener.new, org.bukkit.event.EventPriority::NORMAL, DropItemListener.executor($plugin), $plugin)
Bukkit.get_plugin_manager.register_event(EntityDamageEvent.java_class, EntityDamageListener.new, org.bukkit.event.EventPriority::NORMAL, EntityDamageListener.executor($plugin), $plugin)
Bukkit.get_plugin_manager.register_event(PlayerDeathEvent.java_class, PlayerDeathListener.new, org.bukkit.event.EventPriority::NORMAL, PlayerDeathListener.executor($plugin), $plugin)
$plugin.get_logger.info("Successfully registered listeners event")

# Registering the commands
$plugin.getLifecycleManager.registerEventHandler(LifecycleEvents::COMMANDS) do |event|
  event.registrar.register("kit", KitCommand.new)
  $plugin.get_logger.info("Successfully registered the /kit command")
  event.registrar.register("spawn", SpawnCommand.new)
end

# Initializing the scoreboard
Score.init_scoreboard
$plugin.get_logger.info("Successfully initialized the scoreboard")

# Gamerules configuration
Bukkit.get_worlds.each do |world|
  world.set_game_rule(GameRule::DO_IMMEDIATE_RESPAWN, true)  # Instant respawn
end