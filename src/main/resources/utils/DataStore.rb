# frozen_string_literal: true

java_import Java::net.kyori.adventure.audience.Audience

module DataStore

  class CombatState
    attr_reader :instance, :start_time

    def initialize(player_instance, start_time)
      @instance = player_instance
      @start_time = start_time
    end
  end

  COMBAT_DURATION = 5  # Combat ends 5 seconds after the last damage taken
  @combat_states = {}

  def self.start_combat(player)
    @combat_states[player.get_unique_id] = CombatState.new(player, Time.now)
    Score.set_player_score(player, Score::IN_COMBAT, 1)
    $plugin.get_logger.info("Start of combat for #{player.get_name}")
  end

  def self.in_combat?(player)
    # Player is in combat (true) if its last combat entrance was less than 5 seconds ago
    if @combat_states[player.get_unique_id] == nil
      $plugin.get_logger.info("#{player.get_name} isn't in combat")
      false
    elsif (Time.now - @combat_states[player.get_unique_id].start_time) > DataStore::COMBAT_DURATION
      $plugin.get_logger.info("#{player.get_name} isn't in combat")
      false
    else
      $plugin.get_logger.info("#{player.get_name} is in combat (since #{(Time.now - @combat_states[player.get_unique_id].start_time)}s)")
      true
    end
  end

  def self.end_combat(player)
    # Removes the player from the dict, so `in_combat?` will return false
    @combat_states.delete(player.get_unique_id)
    Score.set_player_score(player, Score::IN_COMBAT, 0)
    $plugin.get_logger.info("End of combat for #{player.get_name}")
  end

  def self.update_combat_states
    @combat_states.each do |_uuid, combat_state|
      # Combat is over
      combat_duration = Time.now - combat_state.start_time
      if combat_duration >= DataStore::COMBAT_DURATION
        self.end_combat(combat_state.instance)
        combat_state.instance.send_action_bar(Component.text("You are no longer in combat").color(NamedTextColor::GRAY))
      else
        combat_state.instance.send_action_bar(
          Component.text("In combat - #{(DataStore::COMBAT_DURATION - combat_duration).round}s")
                   .color(NamedTextColor::RED)
        )
      end
    end
  end

end