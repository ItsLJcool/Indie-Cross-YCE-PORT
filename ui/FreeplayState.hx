//a
import LoadingState;
import CoolUtil;
import Settings;
import Script;
var autoPlaySongs = false;
function onChangeSelection() {
    if (autoPlaySongs) {
        var ost = Paths.modInst(_songs[curSelected].songName, _songs[curSelected].mod, _songs[curSelected].difficulties[curDifficulty]);
        if (ost != null) {
            FlxG.sound.playMusic(ost, 0);
            FlxG.sound.music.persist = true; }
        }
}

function create() {
	var transition:Script;
    trace(Script.create(Paths.modsPath+"/"+mod+"/global_scripts/die"));
    trace(Paths.modsPath+"/"+mod+"/global_scripts/die");
    transition = Script.create(Paths.modsPath+"/"+mod+"/global_scripts/die");
    transition.setVariable("create", function(){});
    transition.setVariable("FlxG", FlxG);
    transition.setScriptObject(this);
    transition.loadFile();
    transition.executeFunc("create");
}

var cupTea:FlxSprite;
function createPost() {
    cupTea = new FlxSprite();
    cupTea.frames = Paths.getSparrowAtlas('cuphead/the_thing2.0');
    cupTea.animation.addByPrefix('start', "BOO instance 1", 24, false);
    cupTea.setGraphicSize(Std.int((FlxG.width / FlxG.camera.zoom) * 1.1), Std.int((FlxG.height / FlxG.camera.zoom) * 1.1));
    cupTea.updateHitbox();
    cupTea.screenCenter();
    cupTea.antialiasing = EngineSettings.antialiasing;
    cupTea.scrollFactor.set();
    cupTea.alpha = 0.0001;
    add(cupTea);

    if (save.data.hasSeenDialogue == null) {
        save.data.hasSeenDialogue = false;
        save.flush();
    }
}

function onSelect(song:SongMetadata) {
    save.data.hasSeenDialogue = false;
    save.flush();
    switch(song.songName) {
        case 'knockout', 'technicolor-tussle', 'snake-eyes', 'devils-gambit':
			Settings.engineSettings.data.lastSelectedSong = _songs[curSelected].mod + ":" +_songs[curSelected].songName.toLowerCase();
			Settings.engineSettings.data.lastSelectedSongDifficulty = curDifficulty;
            FlxG.sound.music.stop();
            cupTea.alpha = 1;
            cupTea.animation.play('start', true, true);
            FlxG.sound.play(Paths.sound('cuphead/boing'), 1);
            new FlxTimer().start(1.1, function(tmr:FlxTimer) {
                CoolUtil.loadSong(_songs[curSelected].mod, _songs[curSelected].songName.toLowerCase(), _songs[curSelected].difficulties[curDifficulty], _songs[curSelected].difficulties);
                LoadingState.loadAndSwitchState(new PlayState());
            });
            return false;
    }
}