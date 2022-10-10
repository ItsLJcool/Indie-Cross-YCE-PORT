//a
var black:FlxSprite; // fade in shit
var introName:FlxSprite;
var bgLMAOsoftHardCode:FlxSprite;
var transCool:FlxSprite;
var stairsss:FlxSprite;
// var scrollingStairBG:FlxSprite;
// var scrollingStairBG2:FlxSprite;
// var scrollingStairBG3:FlxSprite;
// var scrollingStairBG4:FlxSprite;
// var scrollingStairBG5:FlxSprite;
var scrollingStairBGarray:Array<FlxSprite> = [];
var glowStairs:FlxSprite;
var normalBGactive = true;
var stairsActive = false;
var inkMacActive = false;
var stairsOff:Int;

var inkMacBG:FlxSprite;
var theInkMachine:FlxSprite;
var inkMacRailings:Array<FlxSprite> = [];
var inkMacObj:FlxSprite;
var inkMacObj2:FlxSprite;

var chainsInkMac:FlxSprite;
var blackOverlayInkMac:FlxSprite;

var healthTweenObj:FlxTween;

function create() {
    
	healthTweenObj = FlxTween.tween(this, {}, 0);

    EngineSettings.botplay = true;
    PlayState.isWidescreen = false;
    //-17010  -898  sc: 3
    bgLMAOsoftHardCode = new FlxSprite(-23105, -1476); //-17010, -898
    bgLMAOsoftHardCode.frames = Paths.getSparrowAtlas('bendy/run/Fuck_the_hallway');
    bgLMAOsoftHardCode.animation.addByPrefix('Loop1', 'Loop01 instance 1', 72, false);
    bgLMAOsoftHardCode.animation.addByPrefix('Loop2', 'Loop02 instance 1', 72, false);
    bgLMAOsoftHardCode.animation.addByPrefix('Loop3', 'Loop03 instance 1', 72, false);
    bgLMAOsoftHardCode.animation.addByPrefix('Loop4', 'Loop04 instance 1', 72, false);
    bgLMAOsoftHardCode.animation.addByPrefix('Loop5', 'Loop05 instance 1', 72, false);
    bgLMAOsoftHardCode.animation.addByPrefix('Tunnel', 'Tunnel instance 1', 72, false);
    bgLMAOsoftHardCode.animation.play('Loop1');
    bgLMAOsoftHardCode.antialiasing = EngineSettings.antialiasing;
    bgLMAOsoftHardCode.scale.set(4,4); //3,3
    bgLMAOsoftHardCode.updateHitbox();
    PlayState.add(bgLMAOsoftHardCode);
    PlayState.remove(PlayState.dad);
    PlayState.remove(PlayState.boyfriend);
    PlayState.remove(PlayState.gf);
    // PlayState.gf.y = 9999;
    PlayState.gf.visible = false;

    var scrollingOffsetY:Array<Int> = [-1680,2057,-5417,-9154,5417];
    for (i in 0...scrollingOffsetY.length) {
        var scrollingStairBG = new FlxSprite(-2077, scrollingOffsetY[i]).loadGraphic(Paths.image('bendy/stairs/scrollingBG'));
        scrollingStairBG.scale.set(2.5,2.5);
        scrollingStairBG.antialiasing = EngineSettings.antialiasing;
        scrollingStairBG.updateHitbox();
        scrollingStairBG.visible = false;
        scrollingStairBGarray[i] = scrollingStairBG;
        PlayState.add(scrollingStairBGarray[i]);
    }

    theInkMachine = new FlxSprite(-1787,-1457).loadGraphic(Paths.image('bendy/gay/C_02'));
    theInkMachine.scrollFactor.set(0.13,1);
    theInkMachine.scale.set(2.5,2.5);
    theInkMachine.visible = false;
    theInkMachine.antialiasing = EngineSettings.antialiasing;
    theInkMachine.updateHitbox();
    PlayState.add(theInkMachine);

    glowStairs = new FlxSprite(0,0).loadGraphic(Paths.image('bendy/stairs/gradient'));
    glowStairs.antialiasing = EngineSettings.antialiasing;
    //glowStairs.scale.set(2.5,2.5);
    glowStairs.visible = false;
    glowStairs.cameras = [PlayState.camHUD];
    glowStairs.updateHitbox();
    PlayState.add(glowStairs);

    trace("BOYMAN X: " + PlayState.boyfriend.x);
    trace("BOYMAN Y: " + PlayState.boyfriend.y);
    trace("FATHERLESS X: " + PlayState.dad.x);
    trace("FATHERLESS Y:" + PlayState.dad.y);
    
    chainsInkMac = new FlxSprite(0,0).loadGraphic(Paths.image('bendy/gay/C_05'));
    chainsInkMac.antialiasing = EngineSettings.antialiasing;
    chainsInkMac.visible = false;
    chainsInkMac.cameras = [PlayState.camHUD];
    chainsInkMac.scale.set(0.65,0.65);
    chainsInkMac.updateHitbox();
    chainsInkMac.screenCenter();
    PlayState.add(chainsInkMac);

}

function createPost() {

    stairsss = new FlxSprite(-1600,-880).loadGraphic(Paths.image('bendy/stairs/stairs'));
    stairsss.antialiasing = EngineSettings.antialiasing;
    stairsss.scale.set(2.5,2.5);
    stairsss.updateHitbox();
    stairsss.visible = false;
    PlayState.add(stairsss);

    blackOverlayInkMac = new FlxSprite(0,0).loadGraphic(Paths.image('bendy/gay/C_07'));
    blackOverlayInkMac.antialiasing = EngineSettings.antialiasing;
    blackOverlayInkMac.cameras = [PlayState.camHUD];
    blackOverlayInkMac.scale.set(0.8,0.8);
    blackOverlayInkMac.updateHitbox();
    blackOverlayInkMac.screenCenter();
    blackOverlayInkMac.visible = false;
    PlayState.add(blackOverlayInkMac);

    inkMacBG = new FlxSprite(-2478,-1842).loadGraphic(Paths.image('bendy/gay/C_01'));
    inkMacBG.antialiasing = EngineSettings.antialiasing;
    inkMacBG.scale.set(3,3);
    inkMacBG.visible = false;
    inkMacBG.updateHitbox();
    PlayState.add(inkMacBG);

    inkMacObj = new FlxSprite(-1638,-1445).loadGraphic(Paths.image('bendy/gay/C_03'));
    inkMacObj.antialiasing = EngineSettings.antialiasing;
    inkMacObj.scrollFactor.set(0.1,1);
    inkMacObj.scale.set(2.5,2.5);
    inkMacObj.visible = false;
    inkMacObj.updateHitbox();
    PlayState.add(inkMacObj);

    inkMacObj2 = new FlxSprite(-1763,-1363).loadGraphic(Paths.image('bendy/gay/C_04'));
    inkMacObj2.antialiasing = EngineSettings.antialiasing;
    inkMacObj2.scrollFactor.set(0.15,1);
    inkMacObj2.scale.set(2.5,2.5);
    inkMacObj2.visible = false;
    inkMacObj2.updateHitbox();
    PlayState.add(inkMacObj2);

    PlayState.add(PlayState.dad);
    PlayState.add(PlayState.boyfriend);

    var offsetArrayX:Array<Int> = [-5937,-2098,1742,5581];
    for (i in 0...offsetArrayX.length) {
        var inkMacRailing = new FlxSprite(offsetArrayX[i], -1077).loadGraphic(Paths.image('bendy/gay/C_01'));
        inkMacRailing.scale.set(2,2);
        inkMacRailing.updateHitbox();
        inkMacRailing.visible = false;
        inkMacRailings[i] = inkMacRailing;
        PlayState.add(inkMacRailings[i]);
    }
    
    bgLoopHandler();
}

function createInFront() {
    transCool = new FlxSprite(0,0);
    transCool.frames = Paths.getSparrowAtlas('bendy/dark/Trans');
    transCool.animation.addByPrefix('trans', 'beb instance 1', 24, false);
    transCool.animation.play('trans');
    transCool.antialiasing = EngineSettings.antialiasing;
    transCool.cameras = [PlayState.camHUD];
    transCool.visible = false;
    transCool.updateHitbox();
    PlayState.add(transCool);

    black = new FlxSprite(-1000,-600).makeGraphic(FlxG.width * 6, FlxG.height * 6, 0xFF000000);
    black.scrollFactor.set();
    black.updateHitbox();
    PlayState.add(black);
    
    oldCharacterBendy = PlayState.dad;

    newCharacterBendy = new Character(PlayState.dad.x, PlayState.dad.y, mod + ":" + "BendyNMrunDark");
    newCharacterBendy.visible = false;
    PlayState.dads.push(newCharacterBendy);
    PlayState.add(newCharacterBendy);

    // BF
    // Sets the old character as the current character.
    oldCharacterBF = PlayState.boyfriend;

    newCharacterBF = new Boyfriend(PlayState.boyfriend.x, PlayState.boyfriend.y, mod + ":" + "BF-NMrunDark");
    newCharacterBF.visible = false;
    PlayState.boyfriends.push(newCharacterBF);
    PlayState.add(newCharacterBF);
}

var shutUp:Float = 0;
function update() {
    if (stairsActive) {
            PlayState.camFollow.x = 400;
            PlayState.camFollow.y = 150;
            FlxG.camera.zoom = 0.4; // 0.4 || 4
            FlxG.camera.focusOn(PlayState.camFollow.getPosition()); // disables camMove || why I add this? because fuck you
    }
    else if (inkMacActive) {
        PlayState.camFollow.x = 550;
        PlayState.camFollow.y = -150;
        FlxG.camera.focusOn(PlayState.camFollow.getPosition());

        FlxG.camera.zoom = 0.25; // default is 0.6 i think
        PlayState.boyfriend.x = 828.333333333333;
        PlayState.boyfriend.y = -12.5;
        PlayState.dad.x = -768.333333333333;
        PlayState.dad.y = 36.6666666666667;
    }
    //dad
    newCharacterBendy.x =  PlayState.dad.x;
    newCharacterBendy.y =  PlayState.dad.y;
    //Bf
    newCharacterBF.x =  PlayState.boyfriend.x;
    newCharacterBF.y =  PlayState.boyfriend.y;

	PlayState.boyfriend.animation.finishCallback = function(animName:String) {
		PlayState.boyfriend.playAnim(PlayState.boyfriend.animation.curAnim.name, true, false, shutUp);
	}
	PlayState.boyfriend.animation.curAnim.curFrame = shutUp;

	PlayState.dad.animation.finishCallback = function(animName:String) {
		PlayState.dad.playAnim(PlayState.boyfriend.animation.curAnim.name, true, false, shutUp);
	}
	PlayState.dad.animation.curAnim.curFrame = shutUp;

	if (EngineSettings.fpsCap >= 120)
		shutUp += 0.2;
	else if (EngineSettings.fpsCap <= 60)
		shutUp += 0.4;
	if (shutUp >= 11)
		shutUp = 0;

    PlayState.boyfriend.x = FlxMath.lerp(PlayState.boyfriend.x, 1040 + (PlayState.health * 100), 0.07);
    PlayState.dad.x = FlxMath.lerp(PlayState.dad.x, -400 + (PlayState.health * -300), 0.07);

}
/*
stairsOff = (stairsss.width - (PlayState.dad.y-stairsss.y))* -1210 / stairsss.width;
PlayState.dad.y = stairsss.y + -stairsOff;
stairsOff = (stairsss.width - (PlayState.boyfriend.y-stairsss.y))* -1769 / stairsss.width;
PlayState.boyfriend.y = -1210 + stairsss.y + -stairsOff; */

function beatHit(curBeat:Int) {
    switch(curBeat) {
        case 102:
            switchToTunnel();
        case 413:
            switchToTunnel();

        case 135:
            switchToNormal();
        case 324:
            switchToNormal();
        case 481:
            switchToNormal();

        case 191:
            switchToStairs();
        case 262:
            switchToInkMachine();
    }
}
var doOnce = false;
function bgLoopHandler() {
    if (!doOnce) {
        FlxG.camera.focusOn(PlayState.camFollow.getPosition());
        doOnce = true;
    }
    bgLMAOsoftHardCode.visible = true;
    for (i in 0...scrollingStairBGarray.length) {
        scrollingStairBGarray[i].visible = false; }

    for (i in 0...inkMacRailings.length) {
        inkMacRailings[i].visible = false; }

    stairsss.visible = false;
    glowStairs.visible = false;
    theInkMachine.visible = false;
    inkMacObj.visible = false;
    inkMacObj2.visible = false;
    chainsInkMac.visible = false;
    blackOverlayInkMac.visible = false;

    var loopRNG = FlxG.random.int(1,5);
    if (normalBGactive) {
        bgLMAOsoftHardCode.animation.play('Loop' + loopRNG);
        bgLMAOsoftHardCode.animation.finishCallback = function(animName:String) {
            if (normalBGactive) {
                bgLoopHandler(); } 
            }
    }
    else {
        bgLMAOsoftHardCode.animation.play('Tunnel');
        bgLMAOsoftHardCode.animation.finishCallback = function(animName:String) {
            if (!stairsActive || !inkMacActive) {
                bgLoopHandler(); }
        }
    }
}

function switchToTunnel() {
    transCool.visible = true;
    normalBGactive = false;
    transCool.animation.play('trans');
    new FlxTimer().start(.6, function(tmr:FlxTimer) {
        bgLoopHandler();
        newCharacterBF.visible = true;
        newCharacterBendy.visible = true;

        PlayState.boyfriend.visible = false;
        PlayState.dad.visible = false;
    });
    transCool.animation.finishCallback = function(animName:String) {
        transCool.visible = false; }
}
function switchToNormal() {
    transCool.visible = true;
    normalBGactive = true;
    transCool.animation.play('trans');
    new FlxTimer().start(.6, function(tmr:FlxTimer) {
        bgLoopHandler();
        inkMacActive = false;
        stairsActive = false;
        newCharacterBF.visible = false;
        newCharacterBendy.visible = false;

        PlayState.boyfriend.visible = true;
        PlayState.dad.visible = true;
    });
    transCool.animation.finishCallback = function(animName:String) {
        transCool.visible = false; }
}
function switchToStairs() {
    transCool.visible = true;
    transCool.animation.play('trans');
    new FlxTimer().start(.6, function(tmr:FlxTimer) {
        PlayState.camGame.height = 2880;
        stairTweenLoop();
    });
    transCool.animation.finishCallback = function(animName:String) {
        transCool.visible = false; }
    
}
function switchToInkMachine() {
    transCool.visible = true;
    transCool.animation.play('trans');
    new FlxTimer().start(.6, function(tmr:FlxTimer) {
        theInkLol();
        newCharacterBF.visible = true;
        newCharacterBendy.visible = true;
        
        PlayState.boyfriend.visible = false;
        PlayState.dad.visible = false;
    });
    transCool.animation.finishCallback = function(animName:String) {
        transCool.visible = false; }
}
function stairTweenLoop() {
    for (i in 0...scrollingStairBGarray.length) {
        scrollingStairBGarray[i].visible = true;
    }
    stairsss.visible = true;
    glowStairs.visible = true;

    bgLMAOsoftHardCode.visible = false;
    stairsActive = true;
    normalBGactive = false;
    // BF
    PlayState.boyfriend.x = -1770 + 30; // -1770 -- 3960
    PlayState.boyfriend.y = 446;   // 446 -- -1769
    FlxTween.tween(PlayState.boyfriend, {x: 3960, y: -1769 - 60}, 2.5, {ease: FlxEase.linear, type: 1});
    // Dad
    PlayState.dad.x = -3423 + 30; // -3423 -- 2100
    PlayState.dad.y = 965;  // 965 -- -1210
    FlxTween.tween(PlayState.dad, {x: 2100, y: -1210 - 60}, 2.5, {ease: FlxEase.linear, type: 1});
    // stair tween
    // default lol: y: -880
    // stairsss.y = -3800;
    stairsss.y = -880;
    PlayState.camGame.y = -2150;
    camHudTween = FlxTween.tween(PlayState.camGame, {y: 0}, 2.5, {ease: FlxEase.linear, type: 1, onComplete: function() {
        if (stairsActive) {
        stairTweenLoop(); }
    }});
}

function theInkLol() {
    PlayState.camGame.height = 720;
    stairsActive = false;
    inkMacActive = true;
    normalBGactive = false;

    for (i in 0...scrollingStairBGarray.length) {
        scrollingStairBGarray[i].visible = false;
    }
    stairsss.visible = false;
    glowStairs.visible = false;
    bgLMAOsoftHardCode.visible = false;
    theInkMachine.visible = true;
    inkMacObj.visible = true;
    inkMacObj2.visible = true;
    chainsInkMac.visible = true;
    blackOverlayInkMac.visible = true;

    for (i in 0...inkMacRailings.length) {
        inkMacRailings[i].visible = true;
        trace(inkMacRailings[i]);
        FlxTween.tween(inkMacRailings[i], {x: -5937 + inkMacRailings[i].x}, 2.5, {ease: FlxEase.linear, type: 2}); 
    }

    FlxTween.tween(theInkMachine, {x: theInkMachine.x - 2000}, 80, {ease: FlxEase.linear, type: 1});
    FlxTween.tween(inkMacObj, {x: theInkMachine.x - 2000}, 80, {ease: FlxEase.linear, type: 1});
    FlxTween.tween(inkMacObj2, {x: theInkMachine.x - 2000}, 80, {ease: FlxEase.linear, type: 1});

}

// da end of the beginning
function onCountdown(val:Int) {
    switch(val) {
        case 3:
            introName = new FlxSprite().loadGraphic(Paths.image('bendy/introductionsong4'));
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

function onDadHit(note:Note) {
    if (healthBar.percent > 19.95 && !note.isSustainNote) healthTween(-0.05);
}

function healthTween(amt:Float) {
    healthTweenObj.cancel();
    healthTweenObj = FlxTween.num(health, health + amt, 0.1, {ease: FlxEase.cubeInOut}, function(v:Float)
    {
        health = v;
    });
}