//a
import ("LoadingState");
import ("lime.app.Application"); // testing cool shit
// import ("openfl.display.BlendMode");

var bfLOL:FlxSprite;
var bg:FlxSprite;
var logoIC:FlxSprite;
var cupheadCircle:FlxSprite;
var sansCircle:FlxSprite;
var bendyCircle:FlxSprite;
var overlay:FlxSprite;
var playButton:FlxSprite;
var playName:FlxSprite;
var indieCrocks:FlxSprite;

function create() {
    Conductor.changeBPM(117); // L Config File

    bg = new FlxSprite(0,0);
    bg.frames = Paths.getSparrowAtlas('title/Bg');
    bg.animation.addByPrefix('Bg', 'ddddd instance 1', 24);
    bg.animation.play('Bg');
    bg.antialiasing = EngineSettings.antialiasing;
    bg.updateHitbox();
    add(bg);
    
    bfLOL = new FlxSprite(690.5,181);
    bfLOL.frames = Paths.getSparrowAtlas('title/BF');
    bfLOL.animation.addByPrefix('BF', 'BF idle dance instance 1', 24);
    bfLOL.animation.play('BF');
    bfLOL.antialiasing = EngineSettings.antialiasing;
    bfLOL.blend = 0;
    bfLOL.updateHitbox();
    add(bfLOL);
    
    playButton = new FlxSprite(687,579.5);
    playButton.frames = Paths.getSparrowAtlas('title/Playbutton');
    playButton.animation.addByPrefix('button', 'Button instance 1', 24, true);
    playButton.animation.play('button');
    playButton.antialiasing = EngineSettings.antialiasing;
    playButton.scale.set(0.898,0.898);
    playButton.blend = 0;
    playButton.updateHitbox();
    add(playButton);

    playName = new FlxSprite(724,586.5).loadGraphic(Paths.image('title/PlayText'));
    playName.antialiasing = EngineSettings.antialiasing;
    playName.scale.set(0.905,0.905);
    playName.updateHitbox();
    add(playName);

    cupheadCircle = new FlxSprite(-64,-17).loadGraphic(Paths.image('title/CupCircle'));
    cupheadCircle.antialiasing = EngineSettings.antialiasing;
    cupheadCircle.scale.set(0.835,0.835);
    cupheadCircle.blend = 0;
    cupheadCircle.updateHitbox();
    add(cupheadCircle);
    FlxTween.angle(cupheadCircle, 0, 360, 6, {ease: FlxEase.linear, type: 2});

    bendyCircle = new FlxSprite(604,55).loadGraphic(Paths.image('title/BendyCircle'));
    bendyCircle.antialiasing = EngineSettings.antialiasing;
    bendyCircle.scale.set(0.834,0.834);
    bendyCircle.blend = 0;
    bendyCircle.updateHitbox();
    add(bendyCircle);
    FlxTween.angle(bendyCircle, 0, 360, 6, {ease: FlxEase.linear, type: 2});
    
    sansCircle = new FlxSprite(358.5,-57.5).loadGraphic(Paths.image('title/SansCircle'));
    sansCircle.antialiasing = EngineSettings.antialiasing;
    sansCircle.scale.set(0.834,0.834);
    sansCircle.blend = 0;
    sansCircle.updateHitbox();
    add(sansCircle);
    FlxTween.angle(sansCircle, 0, -360, 6, {ease: FlxEase.linear, type: 2});

    logoIC = new FlxSprite(-13.5, 45.5);
    logoIC.frames = Paths.getSparrowAtlas('title/logo');
    logoIC.animation.addByPrefix('bump', 'Tween 11 instance 1', 24);
    logoIC.animation.play('bump');
    logoIC.antialiasing = EngineSettings.antialiasing;
    logoIC.scale.set(0.835,0.835);
    logoIC.blend = 0;
    logoIC.updateHitbox();
    add(logoIC);

    indieCrocks = new FlxSprite(0,0).loadGraphic(Paths.image('title/INDIE CROCKS'));
    indieCrocks.antialiasing = EngineSettings.antialiasing;
    indieCrocks.scale.set(2,2);
    indieCrocks.visible = false;
    indieCrocks.updateHitbox();
    indieCrocks.screenCenter();
    add(indieCrocks);
}

function beatHit(curBeat:Int) {
    bg.animation.play('Bg', true);
    bfLOL.animation.play('BF', true);
    logoIC.animation.play('bump', true);
    
    super.beatHit();
}
var char:Int = 0;
// keys cool
var controls = FlxG.keys.pressed;
var controlsJust = FlxG.keys.justPressed;
var controlsJustNUM = FlxControls.anyJustPressed;
var controlsNUM = FlxControls.anyPressed;
function update(elapsed:Float) {
    var pressed = false;
    if (char == 0) pressed = controlsJust.I;
    if (char == 1) pressed = controlsJust.N;
    if (char == 2) pressed = controlsJust.D;
    if (char == 3) pressed = controlsJust.I;
    if (char == 4) pressed = controlsJust.E;
    if (char == 5) pressed = controlsJust.C;
    if (char == 6) pressed = controlsJust.R;
    if (char == 7) pressed = controlsJust.O;
    if (char == 8) pressed = controlsJust.C;
    if (char == 9) pressed = controlsJust.S;
    if (pressed) {
        char++;
        FlxG.sound.play(Paths.sound('type'));
    } else {
        if (controlsJust.ANY) {
            if (char >= 1)
            FlxG.sound.play(Paths.sound('delete'));
            char = 0;
            trace("You Fucked Up Indie Crocs Spelling");
        }
    }
    if (char >= 10) {
        char = 0;
        trace("Indie Crocs Image");
        indieCrocks.visible = !indieCrocks.visible;
    }
}
var doVideo:Bool = true;
var videoSprite:FlxSprite = null;
var beforeVol = FlxG.sound.volume;
function textShit(beat:Int) {
    if (doVideo) {
    FlxG.sound.music.stop();
    FlxG.sound.volume = 1;
    var mFolder = Paths_.modsPath;
    var path = mFolder + "\\" + mod + "\\videos\\" + "intro.mp4"; // intro
    videoSprite = MP4Video.playMP4(path, function() {
        doVideo = false;
        state.remove(videoSprite);
        FlxG.sound.volume = beforeVol;
		CoolUtil.playMenuMusic(true);
    },false);
    state.add(videoSprite);
    videoSprite.scrollFactor.set();
    } // prevent default behaviour
    return false;
}
function onSkipIntroPost() {
    if (videoSprite == null)
        skippedIntro = false;
}
//117 bpm???

// function create() {
//     super.create();
//     if (!note.mustPress) {
//       note.splashes = Paths.splashes("");
//     }
//   }