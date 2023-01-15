//a
import sys.FileSystem;
import haxe.Json;
import sys.io.File;
import haxe.io.Path;

function create() {
    if (!FileSystem.exists("mods/" + mod + "/song_conf.json")) return;
	configSong = Json.parse(File.getContent("mods/" + mod + "/song_conf.json"));
    
    for (song in configSong.songs) {
        if (song.cutscene == null) song.cutscene = "cutscenes/dialogue";
    }
    File.saveContent("mods/" + mod + "/song_conf.json", Json.stringify(configSong, null, "\t"));
    
    forceCutscenes = FileSystem.exists("mods/" + mod + "/data/" + PlayState.song.song.toLowerCase() + "/dialogue.json");
}