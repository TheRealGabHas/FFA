# frozen_string_literal: true

$plugin.get_logger.info("Ruby is running inside Paper!")
java_import 'org.bukkit.Bukkit'
java_import 'org.bukkit.event.player.PlayerJoinEvent'
java_import 'org.bukkit.event.Listener'
java_import 'org.bukkit.plugin.EventExecutor'

CLASSES = %w[listeners/PlayerJoinListener.rb listeners/BlockBreakListener.rb]
CLASSES.each do |path|
  $plugin.get_logger.info("Attempting to load: #{path}")
  start = Time.now
  stream = $plugin.get_resource(path)
  if stream.nil?
    $plugin.get_logger.severe("Failed to find resource: #{path}")
    next
  end

  content_bytes = stream.read_all_bytes
  stream.close

  eval(String.from_java_bytes(content_bytes))
  $plugin.get_logger.info("Loaded #{path} in #{Time.now - start}s (#{content_bytes.length} bytes)")
end


# Registering the event manually (Event class, Listener instance, Priority, Executor, Plugin)
Bukkit.get_plugin_manager.register_event(PlayerJoinEvent.java_class, PlayerJoinListener.new, org.bukkit.event.EventPriority::NORMAL, PlayerJoinListener.executor($plugin), $plugin)
Bukkit.get_plugin_manager.register_event(BlockBreakEvent.java_class, BlockBreakListener.new, org.bukkit.event.EventPriority::NORMAL, BlockBreakListener.executor($plugin), $plugin)

$plugin.get_logger.info("Successfully registered PlayerJoinEvent via Executor!")
