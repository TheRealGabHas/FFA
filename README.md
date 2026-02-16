# FFA

A Minecraft FFA plugin made in Ruby with PaperMC and JRuby.

## Description

This plugin attempts to implement the Free for all (FFA) game mode.
Players will be able to select a kit with the `/kit` command and go fight others in an arena.

## Commands

Syntax:
- `(argument)`: argument is optional
- `[argument]`: argument is mandatory

### `/kit (number)`

Open the kit selection GUI. If the `number` is provided, the player receive the corresponding kit directly.

## Project structure

The Ruby code is located in the [`resources`](src/main/resources) directory.
The [`main.rb`](src/main/resources/main.rb) script is loaded on plugin startup (by [`FFA.java`](src/main/java/fr/gabhas/FFA/FFA.java)).

This script loads and register multiple listeners, commands and utility for the plugin.