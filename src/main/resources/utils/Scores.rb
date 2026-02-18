# frozen_string_literal: true

java_import org.bukkit.Bukkit
java_import org.bukkit.scoreboard.Scoreboard
java_import org.bukkit.scoreboard.ScoreboardManager
java_import org.bukkit.scoreboard.Criteria

java_import Java::net.kyori.adventure.text.Component


module Score
  CURRENT_KIT = "currentKit"
  IN_ARENA = "inArena"
  IN_COMBAT = "inCombat"
  LIFETIME_KILL_COUNT = "lifetimeKillCount"
  STREAK_KILL_COUNT = "streakKillCount"

  def self.init_scoreboard
    scoreboard = Bukkit.get_scoreboard_manager.get_main_scoreboard
    if scoreboard.get_objective(Score::CURRENT_KIT).nil?
      scoreboard.register_new_objective(Score::CURRENT_KIT, Criteria::DUMMY, Component.text(Score::CURRENT_KIT))
    end
    if scoreboard.get_objective(IN_ARENA).nil?
      scoreboard.register_new_objective(Score::IN_ARENA, Criteria::DUMMY, Component.text(Score::IN_ARENA))
    end
    if scoreboard.get_objective(IN_COMBAT).nil?
      scoreboard.register_new_objective(Score::IN_COMBAT, Criteria::DUMMY, Component.text(Score::IN_COMBAT))
    end
  end

  def self.check_score_existence(score_name)
    scoreboard = Bukkit.get_scoreboard_manager.get_main_scoreboard
    if scoreboard.get_objective(score_name).nil?
      self.init_scoreboard
      if scoreboard.get_objective(score_name).nil?
        $plugin.get_logger.warning("Couldn't set the score #{score_name} for #{player.get_name} (score doesn't exist)")
        return false
      else
        return true
      end
    end
    return true
  end

  def self.set_player_score(player, score_name, value)
    return nil unless self.check_score_existence(score_name)
    scoreboard = Bukkit.get_scoreboard_manager.get_main_scoreboard

    objective = scoreboard.get_objective(score_name)
    score = objective.get_score(player.get_name)
    score.set_score(value)

    $plugin.get_logger.info("Score #{score_name} set to #{value} for #{player.get_name}")
  end

  def self.get_player_score(player, score_name)
    return nil unless self.check_score_existence(score_name)

    scoreboard = Bukkit.get_scoreboard_manager.get_main_scoreboard
    objective = scoreboard.get_objective(score_name)
    score = objective.get_score(player.get_name)

    score.is_score_set ? score.get_score : 0
  end
end
