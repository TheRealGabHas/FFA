# frozen_string_literal: true

java_import org.bukkit.Bukkit
java_import org.bukkit.scoreboard.Scoreboard
java_import org.bukkit.scoreboard.ScoreboardManager
java_import org.bukkit.scoreboard.Criteria
java_import org.bukkit.scoreboard.DisplaySlot

java_import Java::io.papermc.paper.scoreboard.numbers.NumberFormat
java_import Java::net.kyori.adventure.text.Component
java_import Java::net.kyori.adventure.text.format.NamedTextColor
java_import Java::net.kyori.adventure.text.format.Style


module Score
  CURRENT_KIT = "currentKit"
  IN_ARENA = "inArena"
  IN_COMBAT = "inCombat"
  LIFETIME_KILL_COUNT = "lifetimeKillCount"
  STREAK_KILL_COUNT = "streakKillCount"
  BEST_KILLSTREAK = "bestKillstreak"
  PLAYER_HEALTH = "playerHealth"
  DEATH_COUNT = "deathCount"

  def self.init_scoreboard
    scoreboard = Bukkit.get_scoreboard_manager.get_main_scoreboard
    if scoreboard.get_objective(Score::CURRENT_KIT).nil?
      scoreboard.register_new_objective(Score::CURRENT_KIT, Criteria::DUMMY, Component.text(Score::CURRENT_KIT))
    end
    if scoreboard.get_objective(Score::IN_ARENA).nil?
      scoreboard.register_new_objective(Score::IN_ARENA, Criteria::DUMMY, Component.text(Score::IN_ARENA))
    end
    if scoreboard.get_objective(Score::IN_COMBAT).nil?
      scoreboard.register_new_objective(Score::IN_COMBAT, Criteria::DUMMY, Component.text(Score::IN_COMBAT))
    end
    if scoreboard.get_objective(Score::LIFETIME_KILL_COUNT).nil?
      scoreboard.register_new_objective(Score::LIFETIME_KILL_COUNT, Criteria::PLAYER_KILL_COUNT, Score::LIFETIME_KILL_COUNT)
    end
    if scoreboard.get_objective(Score::STREAK_KILL_COUNT).nil?
      scoreboard.register_new_objective(Score::STREAK_KILL_COUNT, Criteria::PLAYER_KILL_COUNT, Score::STREAK_KILL_COUNT)
    end
    if scoreboard.get_objective(Score::DEATH_COUNT).nil?
      scoreboard.register_new_objective(Score::DEATH_COUNT, Criteria::DEATH_COUNT, Score::DEATH_COUNT)
    end
    if scoreboard.get_objective(Score::BEST_KILLSTREAK).nil?
      scoreboard.register_new_objective(Score::BEST_KILLSTREAK, Criteria::DUMMY, Score::BEST_KILLSTREAK)
    end
  end

  def self.check_score_existence(score_name)
    scoreboard = Bukkit.get_scoreboard_manager.get_main_scoreboard
    if scoreboard.get_objective(score_name).nil?
      self.init_scoreboard
      if scoreboard.get_objective(score_name).nil?
        $plugin.get_logger.warning("Couldn't set the score #{score_name} for #{player.get_name} (score doesn't exist)")
        return false
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
