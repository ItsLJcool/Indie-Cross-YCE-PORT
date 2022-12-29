//a
import openfl.filters.ShaderFilter;
import flixel.text.FlxTextBorderStyle;
import GameOverSubstate;

// GameOverSubstate.scriptName = mod + ':gameOverScrips/CupheadDies'; // for stuff

var shader:CustomShader; // stolen from blackJack because funny curb

var sansStageLol:FlxSprite;
var sansFlash:FlxSprite;
var sansBONER:FlxSprite;

var blueHitingBF = false;
var orangeHittingBF = false; // shut up ok
var cancelDeath = false;
var canDodge = false;

var rngBlueOrange:Int;

// keys cool
var controls = FlxG.keys.pressed;
var controlsJust = FlxG.keys.justPressed;
var controlsJustNUM = FlxControls.anyJustPressed;
var controlsNUM = FlxControls.anyPressed;

function create() {

    EngineSettings.botplay = true;

    PlayState.remove(PlayState.dad);
    PlayState.remove(PlayState.boyfriend);
    PlayState.remove(PlayState.gf);
    // PlayState.gf.y = 9999;
    PlayState.gf.visible = false;  
    
    sansStageLol = new FlxSprite(-740, -172);
    sansStageLol.frames = Paths.getSparrowAtlas('sans/Nightmare Sans Stage');
    sansStageLol.animation.addByPrefix('normal', 'Normal instance 1', 24, true);
    // sansStageLol.animation.addByPrefix('FLASH', 'dd instance 1', 24, false);
    sansStageLol.animation.addByPrefix('fullBright', 'sdfs instance 1', 24, false);
    sansStageLol.animation.addByIndices('blankNormal', 'Normal instance 1', [0], "", 24, true);
    sansStageLol.animation.play('blankNormal');
    sansStageLol.antialiasing = EngineSettings.antialiasing;
    sansStageLol.scale.set(1.2,1.2);
    sansStageLol.updateHitbox();
    PlayState.add(sansStageLol);

    PlayState.add(PlayState.dad);
    PlayState.add(PlayState.boyfriend);
    
    sansFlash = new FlxSprite(-807, 396);
    sansFlash.frames = Paths.getSparrowAtlas('sans/Nightmare Sans Stage');
    // sansFlash.animation.addByPrefix('normal', 'Normal instance 1', 24, true);
    sansFlash.animation.addByPrefix('FLASH', 'dd instance 1', 24, false);
    // sansFlash.animation.addByPrefix('fullBright', 'sdfs instance 1', 24, false);
    // sansFlash.animation.addByIndices('blankNormal', 'Normal instance 1', [0], "", 24, true);
    sansFlash.visible = false;
    sansFlash.animation.play('FLASH');
    sansFlash.antialiasing = EngineSettings.antialiasing;
    sansFlash.scale.set(1.3,1.3);
    sansFlash.blend = 0;
    sansFlash.updateHitbox();
    PlayState.add(sansFlash);
}

var shader:CustomShader;
function createPost() {
    shader = new CustomShader(mod + ":chromaticAbliteration");
    PlayState.camHUD.setFilters([new ShaderFilter(shader)]);
    PlayState.camHUD.filtersEnabled = true;

    sansBONER = new FlxSprite(610, 460);
    sansBONER.frames = Paths.getSparrowAtlas('sans/Sans_Shit_NM');
    sansBONER.animation.addByPrefix('blueAlarm', 'AlarmBlue instance 1', 24, false);
    sansBONER.animation.addByPrefix('orangeAlarm', 'AlarmOrange instance 1', 24, false);
    sansBONER.animation.addByPrefix('orangeBones', 'Bones Orange instance 1', 24, false);
    sansBONER.animation.addByPrefix('blueBones', 'Bones boi instance 1', 24, false);
    sansBONER.animation.play('blueAlarm');
    sansBONER.antialiasing = EngineSettings.antialiasing;
    sansBONER.blend = 0;
    sansBONER.updateHitbox();
    sansBONER.visible = false;
    PlayState.add(sansBONER);

    for(m in PlayState.members) {
    if (Std.isOfType(m, FlxSprite)) {
        m.antialiasing = true;
        if (Std.isOfType(m, FlxText)) {
            // lol it's actually a built in flixel font
            m.font = Paths.font("sansFont"); // YOSHI DOSN'T NEED THE .tff EXTENSION YES
            m.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000);
            }
        }  
    }
// You know who else has dementia?
}

function onGuiPopup() {
    
}

function beatHit(curBeat) { // CASES USE "," YES
    sansFlash.animation.play('FLASH', true);
    switch(curBeat) {
        case 8, 35, 67, 83, 132, 167, 180, 194, 208, 214, 235, 242, 268, 284, 308, 328, 342, 364:
            onBonesPopup();
    }
}

function stepHit(curStep) {
    switch(curStep) {
        case 384, 768, 1184:
            sansStageLol.animation.play('normal');
            sansFlash.visible = false;
        case 512, 928, 1440:
            sansStageLol.animation.play('fullBright');
            sansFlash.visible = true;
    }
}
var playOnce = false;
var secondPlayOnce = false;

function onBonesPopup() {
    trace("-----------------");
    rngBlueOrange = FlxG.random.int(1,2);
    playOnce = false;
    secondPlayOnce = false;
    FlxG.sound.play(Paths.sound('sans/notice'));
    orangeHittingBF = false;
    blueHitingBF = false;
    cancelDeath = false;
    canDodge = true;
    sansBONER.visible = true;
    switch (rngBlueOrange) {
        case 1: // blue
            sansBONER.animation.play('blueAlarm');
            trace("blueAlarm");
            trace("Sans Visible: " + sansBONER.visible);
            new FlxTimer().start(.6, function(tmr:FlxTimer) {
                sansBONER.animation.play('blueBones');
                canDodge = false;
                FlxG.sound.play(Paths.sound('sans/sansattack'));
                trace("Sans Visible: " + sansBONER.visible);
                new FlxTimer().start(.35, function(tmr:FlxTimer) {
                    blueHitingBF = true;
                    trace("blueBones");
                });
            });
        case 2: // orange
            sansBONER.animation.play('orangeAlarm');
            trace("orangeAlarm");
            trace("Sans Visible: " + sansBONER.visible);
            new FlxTimer().start(.6, function(tmr:FlxTimer) {
                sansBONER.animation.play('orangeBones');
                canDodge = false;
                FlxG.sound.play(Paths.sound('sans/sansattack'));
                if (cancelDeath) {
                PlayState.boyfriend.playAnim('dodge'); }
                
                trace("Sans Visible: " + sansBONER.visible);
                new FlxTimer().start(.35, function(tmr:FlxTimer) {
                    orangeHittingBF = true;
                    trace("orangeBones");
                });
            });
    }
    sansBONER.animation.finishCallback = function(animName:String) {
        if (sansBONER.animation.curAnim.name == "orangeBones" 
            || sansBONER.animation.curAnim.name == "blueBones") {
            sansBONER.visible = false;
            blueHitingBF = false; 
            trace("invis"); }
    }
}

function update(elapsed) {
    switch (rngBlueOrange) {
        case 1:
            if (controlsJust.SPACE && canDodge && !EngineSettings.botplay) {
                PlayState.boyfriend.playAnim('singUPmiss');
                FlxG.sound.play(Paths.sound('sans/dodge'));
                PlayState.health = -1; }
        case 2:
            if (!controlsJust.SPACE && !cancelDeath && !canDodge && !EngineSettings.botplay) {
                FlxG.sound.play(Paths.sound('sans/dodge'));
                PlayState.health = -1; }
            else if (controlsJust.SPACE && canDodge && !EngineSettings.botplay) {
                FlxG.sound.play(Paths.sound('sans/dodge'));
                cancelDeath = true;
            }
            if (EngineSettings.botplay) {
                new FlxTimer().start(.3, function(tmr:FlxTimer) {
                    if (!playOnce) {
                        FlxG.sound.play(Paths.sound('sans/dodge'));
                        cancelDeath = true;
                        playOnce = true;
                    }
                });
            }
    }
}