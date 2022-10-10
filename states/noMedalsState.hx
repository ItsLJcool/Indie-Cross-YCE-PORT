//a
import('flixel.text.FlxTextBorderStyle');
import ('flixel.addons.effects.FlxTrail'); // failed
var heyTxt:FlxText;
var goBack:FlxText;
var noMoreAchievementsTxt:FlxText;
var menuBG:FlxSprite;
var yoLOGO:FlxSprite;
var youKnowWhatShutTheHellUpBeforeIPunchYourFaceIntoYourselfAndThenJumpOffAbridgeToMakeSureTheFBIdoesntFindMe:FlxSprite; // what I can't make a sprite name long? screw you :troll:

var achTween:FlxTween;

// keys cool
var controls = FlxG.keys.pressed;
var controlsJust = FlxG.keys.justPressed;
var controlsJustNUM = FlxControls.anyJustPressed;
var controlsNUM = FlxControls.anyPressed;

function create() {

    menuBG = new FlxSprite(0,0).loadGraphic(Paths.image('Loading_screen'));
    menuBG.antialiasing = EngineSettings.antialiasing;
    menuBG.scrollFactor.set();
    menuBG.updateHitbox();
    menuBG.screenCenter();
    add(menuBG);

    yoLOGO = new FlxSprite(0,0).loadGraphic(Paths.image('menu/LOGO'));
    yoLOGO.antialiasing = EngineSettings.antialiasing;
    yoLOGO.scale.set(0.675625,0.675625);
    yoLOGO.scrollFactor.set();
    yoLOGO.updateHitbox();
    add(yoLOGO);

    heyTxt = new FlxText();
    heyTxt.text = "Hey!";
    heyTxt.size = 64;
    heyTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000);
    heyTxt.borderSize = 4;
    heyTxt.screenCenter();
    heyTxt.y = 1000;
    add(heyTxt);

    goBack = new FlxText();
    goBack.text = "Press Esc, Enter, Or Backspace To Leave";
    goBack.size = 12;
    goBack.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000);
    goBack.borderSize = 2;
    goBack.y = 700;
    goBack.x = 950;
    goBack.alpha = 0;
    add(goBack);
    
    noMoreAchievementsTxt = new FlxText();
    noMoreAchievementsTxt.text = "Since this version is 1.9.1, YCE Doesn't have medals yet! \n either update the engine or wait till 2.0.0 is released!";
    noMoreAchievementsTxt.size = 32;
    noMoreAchievementsTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000);
    noMoreAchievementsTxt.borderSize = 4;
    noMoreAchievementsTxt.screenCenter();
    noMoreAchievementsTxt.y = 800;
    add(noMoreAchievementsTxt);
    
    youKnowWhatShutTheHellUpBeforeIPunchYourFaceIntoYourselfAndThenJumpOffAbridgeToMakeSureTheFBIdoesntFindMe = new FlxSprite(0,0).loadGraphic(Paths.image('title/INDIE CROCKS'));
    youKnowWhatShutTheHellUpBeforeIPunchYourFaceIntoYourselfAndThenJumpOffAbridgeToMakeSureTheFBIdoesntFindMe.antialiasing = EngineSettings.antialiasing;
    youKnowWhatShutTheHellUpBeforeIPunchYourFaceIntoYourselfAndThenJumpOffAbridgeToMakeSureTheFBIdoesntFindMe.scrollFactor.set();
    youKnowWhatShutTheHellUpBeforeIPunchYourFaceIntoYourselfAndThenJumpOffAbridgeToMakeSureTheFBIdoesntFindMe.scale.set(2,2);
    youKnowWhatShutTheHellUpBeforeIPunchYourFaceIntoYourselfAndThenJumpOffAbridgeToMakeSureTheFBIdoesntFindMe.updateHitbox();
    youKnowWhatShutTheHellUpBeforeIPunchYourFaceIntoYourselfAndThenJumpOffAbridgeToMakeSureTheFBIdoesntFindMe.screenCenter();
    youKnowWhatShutTheHellUpBeforeIPunchYourFaceIntoYourselfAndThenJumpOffAbridgeToMakeSureTheFBIdoesntFindMe.visible = false;
    add(youKnowWhatShutTheHellUpBeforeIPunchYourFaceIntoYourselfAndThenJumpOffAbridgeToMakeSureTheFBIdoesntFindMe);

    coolTransition();

    
}

var char:Int = 0;
var introOver = false;
var leaving = true;
function update(elapsed:Float) {
    
    if (controlsJustNUM([27,8,13]) && introOver && leaving) {
        FlxG.sound.play(Paths.sound('cancelMenu'));
        leaving = true;
        achTween.cancel();
        FlxTween.tween(goBack, {alpha: 0}, 1.5, { ease: FlxEase.quadOut, type: 1});
        FlxTween.tween(noMoreAchievementsTxt, {y: 1000}, 2, {ease: FlxEase.backInOut, type: 1});
        FlxTween.tween(yoLOGO, {y: yoLOGO.y - 200}, 1.5, {ease: FlxEase.backIn, type: 1});
        
        new FlxTimer().start(.2, function(tmr:FlxTimer) {
            FlxTween.tween(heyTxt, {y: 1000}, 2, {ease: FlxEase.backInOut, type: 1, onComplete: function() {
                FlxG.switchState(new ModState('indieCrossMenuState', mod));
        }});
    });
}
        var controlsJust = FlxControls.justPressed;
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
            youKnowWhatShutTheHellUpBeforeIPunchYourFaceIntoYourselfAndThenJumpOffAbridgeToMakeSureTheFBIdoesntFindMe.visible = !youKnowWhatShutTheHellUpBeforeIPunchYourFaceIntoYourselfAndThenJumpOffAbridgeToMakeSureTheFBIdoesntFindMe.visible;
        }
}

function coolTransition() {
    
    // default offset: x: 554 y: 318
    heyTxt.scale.set(0.4,0.4);
    FlxTween.tween(heyTxt, {y: 318}, 1.5, {ease: FlxEase.cubeOut, type: 1, onComplete: function() {
        FlxTween.tween(heyTxt.scale, {x: 1, y: 1}, 1.2, {ease: FlxEase.cubeOut, type: 1, onComplete: function() {
            FlxTween.tween(noMoreAchievementsTxt, {y: 468}, 1.5, {ease: FlxEase.circOut, type: 1, onComplete: function() {
                achTween = FlxTween.tween(noMoreAchievementsTxt, {y: noMoreAchievementsTxt.y + 25}, 0.85, {ease: FlxEase.sineInOut, type: 4});
                introOver = true;
                //goBack
                FlxTween.tween(goBack, {alpha: 1}, 1.5, { ease: FlxEase.quadOut, type: 1});
            }}); 
            }});
            }});
}