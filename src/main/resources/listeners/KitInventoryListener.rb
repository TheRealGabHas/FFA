# frozen_string_literal: true

java_import org.bukkit.event.Listener
java_import org.bukkit.event.inventory.InventoryClickEvent
java_import org.bukkit.Sound
java_import org.bukkit.scoreboard.Scoreboard
java_import org.bukkit.scoreboard.ScoreboardManager
java_import org.bukkit.scoreboard.Criteria

java_import Java::net.kyori.adventure.text.Component


def init_scoreboard
  scoreboard = Bukkit.get_scoreboard_manager.get_main_scoreboard
  if scoreboard.get_objective(SCORE::CURRENT_KIT).nil?
    scoreboard.register_new_objective(SCORE::CURRENT_KIT, Criteria::DUMMY, Component.text(SCORE::CURRENT_KIT))
  end
end

def set_player_score(player, score_name, value)
  scoreboard = Bukkit.get_scoreboard_manager.get_main_scoreboard
  if scoreboard.get_objective(score_name).nil?
    init_scoreboard
    if scoreboard.get_objective(score_name).nil?
      $plugin.get_logger.warning("Couldn't set the score #{score_name} for #{player.get_name} (score doesn't exist)")
    end
  end

  objective = scoreboard.get_objective(score_name)
  score = objective.get_score(player.get_name)
  score.set_score(value)

  $plugin.get_logger.info("Score #{score_name} set to #{value} for #{player.get_name}")
end


class KitInventoryListener
  include Listener

  def self.on_inventory_click(event)
    holder = event.getInventory.get_holder
    return unless holder.is_a?(KitSelectorInventory)

    event.set_cancelled(true)

    player = event.get_who_clicked
    slot = event.get_raw_slot
    return if slot >= holder.get_inventory.get_size  # Only handle the click in the displayed container, not player's inventory

    player.send_message(Component.text("[#{event.get_inventory}] You selected the kit ##{slot + 1}"))
    player.play_sound(player.get_location, Sound::BLOCK_NOTE_BLOCK_PLING, 1.0, 1.0)
    set_player_score(player, "currentKit", slot+1)
  end

  def self.executor(plugin)
    EventExecutor.impl do |_method, _listener, event|
      if event.is_a?(InventoryClickEvent)
        self.on_inventory_click(event)
      end
    end
  end
end