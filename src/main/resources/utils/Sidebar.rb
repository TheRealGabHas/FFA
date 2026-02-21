# frozen_string_literal: true

java_import org.bukkit.Bukkit
java_import org.bukkit.entity.Player
java_import org.bukkit.scoreboard.Scoreboard
java_import org.bukkit.scoreboard.ScoreboardManager
java_import org.bukkit.scoreboard.Criteria
java_import org.bukkit.scoreboard.DisplaySlot

java_import Java::io.papermc.paper.scoreboard.numbers.NumberFormat

java_import Java::net.kyori.adventure.text.Component
java_import Java::net.kyori.adventure.text.format.NamedTextColor
java_import Java::net.kyori.adventure.text.format.TextDecoration


module Sidebar

  def self.create_sidebar(player)
    manager = Bukkit.get_scoreboard_manager
    board = manager.get_new_scoreboard

    sidebar_name = Component.text("Global ").color(NamedTextColor::RED)
                            .append(Component.text("FFA").color(NamedTextColor::YELLOW).decorate(TextDecoration::BOLD))
    objective = board.register_new_objective("sidebar_view", Criteria::DUMMY, sidebar_name)
    objective.set_display_slot(DisplaySlot::SIDEBAR)
    objective.number_format(NumberFormat.blank)

    add_line(board, objective, team_name: "total_kill",
             prefix: Component.text("Kills").color(NamedTextColor::RED),
             score_position: 1)
    add_line(board, objective, team_name: "best_KS",
             prefix: Component.text("Best Streak").color(NamedTextColor::RED),
             score_position: 2)

    board.register_new_objective(Score::PLAYER_HEALTH, Criteria::HEALTH, Component.text("\u2764").color(NamedTextColor::RED))
    health_objective = board.get_objective(Score::PLAYER_HEALTH)
    health_objective.set_display_slot(DisplaySlot::BELOW_NAME)

    display_style = Style.style.color(NamedTextColor::RED).decorate(TextDecoration::BOLD).build
    number_format = NumberFormat.styled(display_style)
    health_objective.number_format(number_format)

    player.set_scoreboard(board)
  end

  def self.add_line(board, objective, team_name:, prefix:, score_position:)
    team = board.register_new_team(team_name)

    entry = "\u00A7#{score_position}" # unique invisible entry
    team.add_entry(entry)

    team.prefix(prefix)
    team.suffix(Component.text(" 0").color(NamedTextColor::AQUA))

    objective.get_score(entry).set_score(score_position)
  end

  def self.update_sidebar(player)
    board = player.get_scoreboard

    kill_count = Score.get_player_score(player, Score::LIFETIME_KILL_COUNT)
    best_killstreak = Score.get_player_score(player, Score::BEST_KILLSTREAK)

    board.get_team("total_kill")&.suffix(Component.text(" #{kill_count}").color(NamedTextColor::AQUA))
    board.get_team("best_KS")&.suffix(Component.text(" #{best_killstreak}").color(NamedTextColor::AQUA))
  end
end