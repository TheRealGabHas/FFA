# gFFA

A Minecraft FFA plugin made in Ruby with PaperMC and JRuby.

## Description

This plugin attempts to implement the Free for all (FFA) game mode.
Players will be able to select a kit with the `/kit` command and go fight others in an arena.

## Requirements

The dependencies are listed in the `build.gradle` file. Here are the development tools utilized :
- Java 23
- JRuby 10.0.3.0

ShadowJar is used in order to include JRuby and its dependencies in the final JAR.

## Commands

Syntax:
- `(argument)`: argument is optional
- `[argument]`: argument is mandatory

### `/kit (number)`

Open the kit selection GUI. If the `number` is provided, the player receive the corresponding kit directly. This 
command doesn't work if the sender is :
- in the arena
- in combat

### `/spawn`

Teleport the player to the spawn if they aren't in combat, therefore leaving the arena.


## Project structure

The Ruby code is located in the [`resources`](src/main/resources) directory.
The [`main.rb`](src/main/resources/main.rb) script is loaded on plugin startup (by [`FFA.java`](src/main/java/fr/gabhas/FFA/FFA.java)).

This script loads and register multiple listeners, commands and utility for the plugin. Since they are loaded in order 
by the same file, something imported by a given file A (loaded before B) can be used in B without explicitly importing 
it in B.

> [!NOTE]
> This plugin was made to work well on a specific map, located in the `world` folder. I attempted to hardcode as little 
> elements as possible so it won't be too hard to adapt it for another map.