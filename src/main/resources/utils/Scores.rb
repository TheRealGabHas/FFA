# frozen_string_literal: true

java_import org.bukkit.Bukkit
java_import org.bukkit.scoreboard.Scoreboard
java_import org.bukkit.scoreboard.ScoreboardManager
java_import org.bukkit.scoreboard.Criteria

java_import Java::net.kyori.adventure.text.Component


module Score
  CURRENT_KIT = "currentKit"
  LIFETIME_KILL_COUNT = "lifetimeKillCount"
  STREAK_KILL_COUNT = "streakKillCount"

  def self.init_scoreboard
    scoreboard = Bukkit.get_scoreboard_manager.get_main_scoreboard
    if scoreboard.get_objective(Score::CURRENT_KIT).nil?
      scoreboard.register_new_objective(Score::CURRENT_KIT, Criteria::DUMMY, Component.text(Score::CURRENT_KIT))
    end
  end

  def self.set_player_score(player, score_name, value)
    scoreboard = Bukkit.get_scoreboard_manager.get_main_scoreboard
    if scoreboard.get_objective(score_name).nil?
      self.init_scoreboard
      if scoreboard.get_objective(score_name).nil?
        $plugin.get_logger.warning("Couldn't set the score #{score_name} for #{player.get_name} (score doesn't exist)")
      end
    end

    objective = scoreboard.get_objective(score_name)
    score = objective.get_score(player.get_name)
    score.set_score(value)

    $plugin.get_logger.info("Score #{score_name} set to #{value} for #{player.get_name}")
  end
end
