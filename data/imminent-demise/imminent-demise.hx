//a
var firstBG:FlxSprite;
var flashingLIGHT:FlxSprite;
var bendyCutout:FlxSprite;
var boppinMusic:FlxSprite;
var pillarLol:FlxSprite;
var black:FlxSprite; // fade in shit
var introName:FlxSprite;
var overlappingBFfix:FlxSprite; // character btw
var bendyOUT = false;

function create() {
    PlayState.isWidescreen = false;

    firstBG = new FlxSprite(-1100, -455).loadGraphic(Paths.image('bendy/first/BG01'));
    firstBG.antialiasing = true;
    firstBG.updateHitbox();
    PlayState.add(firstBG);
    
    // ok bf is not infront of the first bg so stfu ok
    overlappingBFfix = PlayState.boyfriend;
    overlappingBFfix = new Boyfriend(770, 120, mod + ":" + "BF-Imminent");
    overlappingBFfix.visible = true;
    PlayState.boyfriends.push(overlappingBFfix);
    PlayState.add(overlappingBFfix);

    boppinMusic = new FlxSprite(230,142);
    boppinMusic.frames = Paths.getSparrowAtlas('bendy/first/MusicBox');
    boppinMusic.animation.addByPrefix('BOPPIN', 'Music box thingy instance 1', 24, false);
    boppinMusic.antialiasing = EngineSettings.antialiasing;
    //boppinMusic.scrollFactor.set(1.2, 1);
    PlayState.add(boppinMusic);

    flashingLIGHT = new FlxSprite(5,-360);
    flashingLIGHT.frames = Paths.getSparrowAtlas('bendy/first/Light(Add-Blend)');
    flashingLIGHT.animation.addByPrefix('MY EYES', 'fezt instance 1', 24, true);
    flashingLIGHT.antialiasing = EngineSettings.antialiasing;
    flashingLIGHT.animation.play('MY EYES');
    PlayState.add(flashingLIGHT);

    bendyCutout = new FlxSprite(-233,-57).loadGraphic(Paths.image('bendy/first/Boi'));
    //bendyCutout.scrollFactor.set(1.2, 1);
    bendyCutout.antialiasing = EngineSettings.antialiasing;
    bendyCutout.updateHitbox();
    PlayState.add(bendyCutout);

    pillarLol = new FlxSprite(927,-557).loadGraphic(Paths.image('bendy/first/Pillar'));
    pillarLol.scrollFactor.set(1.2, 1);
    pillarLol.antialiasing = EngineSettings.antialiasing;
    pillarLol.updateHitbox();
    PlayState.add(pillarLol);
    cutsceneYo(true); // true means preload
}

function createPost() {
    PlayState.iconP2.changeCharacter("bendyDAgames", mod);
    PlayState.healthBar.createFilledBar(0xFF696B6D, 0xFF31B0D1); // broken lmao
    cutsceneYo(true); // true means preload
}

function beatHit(curBeat:Int) { 
    boppinMusic.animation.play('BOPPIN');// to sync to da beat!
    switch(curBeat) {
        case 235:
            cutsceneYo(false); // false means regular playing since its preloaded
            PlayState.iconP2.changeCharacter("Bendy", mod);
            PlayState.healthBar.createFilledBar(0xFF000000, 0xFF31B0D1); // broken lmao
            PlayState.canPause = false;
        case 282:
            overlappingBFfix.visible = false;
            pillarLol.visible = false;
            bendyCutout.visible = false;
            flashingLIGHT.visible = false;
            boppinMusic.visible = false;
            firstBG.visible = false;
            bendyOUT = true;
            PlayState.canPause = true;
    }
}

function onGuiPopup() {
    black = new FlxSprite(-1000,-600).makeGraphic(FlxG.width * 6, FlxG.height * 6, 0xFF000000);
    black.scrollFactor.set();
    black.updateHitbox();
    PlayState.add(black);
}

function update(elapesed:Float) {
    if (!bendyOUT) {
        if (!PlayState.section.mustHitSection) {
            PlayState.camFollow.x = 400;
            PlayState.camFollow.y = 240; }
        else {
            PlayState.camFollow.x = 725;
            PlayState.camFollow.y = 400; }
        FlxG.camera.zoom = 0.6;
    }
}

// da end of the beginning
function onCountdown(val:Int) {    
    switch(val) {
        case 3:
            introName = new FlxSprite().loadGraphic(Paths.image('bendy/first/introductionsong1'));
            introName.scale.set(0.75,0.75);
            introName.updateHitbox();
            introName.screenCenter();
            introName.cameras = [PlayState.camHUD];
            PlayState.add(introName);
            FlxTween.tween(introName.scale, {x: 1, y: 1}, 4, {ease: FlxEase.linear});
        case 2:
            FlxG.sound.play(Paths.sound('bendy/whoosh'));
        case 1:

        case 0:
            var opacity:{value:Float} = {value: black.alpha};
            FlxTween.tween(opacity, {value: 0}, 2, {ease: FlxEase.linear, onUpdate: twn -> {
                black.alpha = opacity.value; }});
                
            var opacity:{value:Float} = {value: introName.alpha};
            FlxTween.tween(opacity, {value: 0}, 3, {ease: FlxEase.linear, onUpdate: twn -> {
                introName.alpha = opacity.value; }, onComplete: function() {
                    introName.visible = false; }});
    }
    return false;
}

function cutsceneYo(preload:Bool) {
    var mFolder = Paths_.modsPath;
    
    // To get video path in your custom cutscene, type Paths.video("(video file name)");
    var path = mFolder + "\\" + PlayState_.songMod + "\\videos\\" + "bendy\\part2.mp4";
    trace(path);

    var wasWidescreen = PlayState.isWidescreen;
    // Video sprite to be added in game.
    var videoSprite:FlxSprite = null;
    // Assigns the video sprite
    
    // videoSprite.skippable = false;
    videoSprite = MP4Video.playMP4(path,
        // WILL TRIGGER ONCE THE VIDEO ENDS
        function() {
            // Removes the video sprite from the PlayState
            PlayState.remove(videoSprite);
            // Enables widescreen back (or disable it if it was disabled)
            PlayState.isWidescreen = wasWidescreen;
        },
        // If midsong.
        false);
    // Sets the video sprite camera to camHUD, putting it above the HUD.
    videoSprite.cameras = [PlayState.camHUD];
    // Sets the scroll factor to 0
    videoSprite.scrollFactor.set();
    // Disables widescreen
    PlayState.isWidescreen = false;
    // Adds the video sprite.
    PlayState.add(videoSprite);
    if (preload) {
        PlayState.remove(videoSprite); }
}