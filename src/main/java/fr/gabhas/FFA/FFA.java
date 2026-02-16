package fr.gabhas.FFA;

import org.bukkit.plugin.java.JavaPlugin;
import org.jruby.embed.ScriptingContainer;

import java.io.InputStream;
import java.nio.charset.StandardCharsets;

public final class FFA extends JavaPlugin {

    @Override
    public void onEnable() {
        getLogger().info("Starting JRuby...");

        ScriptingContainer rbContainer = new ScriptingContainer();

        // Make the plugin accessible from Ruby as the `($)plugin` variable
        rbContainer.put("$plugin", this);

        try (InputStream is = getResource("main.rb")) {
            if (is == null) {
                getLogger().severe("main.rb not found!");
                return;
            }
            String script = new String(is.readAllBytes(), StandardCharsets.UTF_8);
            rbContainer.runScriptlet(script);
        } catch (Exception e) {
            getLogger().severe(e.toString());
        }
    }

    @Override
    public void onDisable() {
        // Plugin shutdown logic
    }
}
