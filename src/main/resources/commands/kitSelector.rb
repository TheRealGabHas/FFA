# frozen_string_literal: true

java_import org.bukkit.entity.Player
java_import Java::io.papermc.paper.command.brigadier.BasicCommand

java_import Java::net.kyori.adventure.text.Component


class KitCommand
  include BasicCommand

  def execute(source, args)
    sender = source.get_sender
    executor = source.get_executor

    if sender == executor && sender.is_a?(Player)
      # No argument provided, open the GUI selection menu
      if args.length < 1
        sender.send_message(Component.text("This command can also be used like so: /kit <number>"))
        return true
      end

      # Raise an error if the provided argument is not a number
      unless args[0].match?(/\A\d+\z/)
        sender.send_message(Component.text("The first argument must be a number, not a string"))
        return false
      end

      sender.send_message(Component.text("You selected the kit #{args[0].to_i}"))
      true
    end
  end

end