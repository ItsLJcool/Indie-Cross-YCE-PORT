// a
import flixel.text.FlxTextBorderStyle;

var stage:Stage = null;
var infiniteResize:Float = 2.3;

var forcesize = false;
var overrideNMZoom:Bool = false;
var nmStairs:Bool = false;
var inBlackout:Bool = false;

var stairsGrp:Array<FlxSprite> = [];

function create() {
	// stage = loadStage('NMRunStage');

	defaultCamZoom = 0.45;

	PlayState.gf.visible = false;

	PlayState.remove(PlayState.dad);
	PlayState.remove(PlayState.boyfriend);
	PlayState.remove(PlayState.gf);

    // EngineSettings.botplay = true;
    PlayState.isWidescreen = false;
    //-17010  -898  sc: 3
    bg = new FlxSprite(-23105, -1476); //-17010, -898
    bg.frames = Paths.getSparrowAtlas('bendy/run/Fuck_the_hallway');
    bg.animation.addByPrefix('Loop1', 'Loop01 instance 1', 72, false);
    bg.animation.addByPrefix('Loop2', 'Loop02 instance 1', 72, false);
    bg.animation.addByPrefix('Loop3', 'Loop03 instance 1', 72, false);
    bg.animation.addByPrefix('Loop4', 'Loop04 instance 1', 72, false);
    bg.animation.addByPrefix('Loop5', 'Loop05 instance 1', 72, false);
    bg.animation.addByPrefix('Tunnel', 'Tunnel instance 1', 72, false);
    bg.animation.play('Loop1');
	bg.setGraphicSize(Std.int(bg.width * 3));
	bg.updateHitbox();
	bg.screenCenter();
	bg.scrollFactor.set(0.8, 0.8);
	// bg.x -= 100;
	bg.y -= 50;
	bg.antialiasing = EngineSettings.antialiasing;
	bg.graphic.persist = true;
	bg.graphic.destroyOnNoUse = false;
	bg.alpha = 1;
    PlayState.add(bg);
    PlayState.remove(PlayState.dad);
    PlayState.remove(PlayState.boyfriend);
    PlayState.remove(PlayState.gf);
    // PlayState.gf.y = 9999;
    PlayState.gf.visible = false;

	stairsBG = new FlxBackdrop(Paths.image('bendy/stairs/scrollingBG'), 0, 1, false, true);
	stairsBG.screenCenter();
	stairsBG.alpha = 0.0001;
	stairsBG.velocity.set(0, 180);

	stairs = new FlxSprite(0, 0).loadGraphic(Paths.image('bendy/stairs/stairs'));
	stairs.updateHitbox();
	stairs.screenCenter();
	stairs.alpha = 0.0001;
	stairs.antialiasing = EngineSettings.antialiasing;
	stairs.y -= 720;

	stairsGradient = new FlxSprite(0, 0).loadGraphic(Paths.image('bendy/stairs/gradient'));
	stairsGradient.updateHitbox();
	stairsGradient.screenCenter();
	stairsGradient.y -= 1;
	stairsGradient.blend = 11;
}

var yourMOM:FlxText;
EngineSettings.botplay = true;
function createPost() {
	PlayState.add(PlayState.dad);
	PlayState.add(PlayState.boyfriend);

	PlayState.boyfriend.x += 300;
	PlayState.boyfriend.y += 200;
	PlayState.dad.x -= 200;
	PlayState.dad.y += 50;
	
    yourMOM = new FlxText();
    yourMOM.text = "nothing set Yet";
    yourMOM.size = 32;
    yourMOM.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000);
    yourMOM.borderSize = 4;
    yourMOM.screenCenter();
    // add(yourMOM); // she doesn't exist so boom, can't add her
	bgLoopHandler();
}
function createInFront() {
    transCool = new FlxSprite(0,0);
    transCool.frames = Paths.getSparrowAtlas('bendy/dark/Trans');
    transCool.animation.addByPrefix('trans', 'beb instance 1', 24, false);
    transCool.animation.play('trans');
    transCool.antialiasing = EngineSettings.antialiasing;
    transCool.cameras = [PlayState.camHUD];
    transCool.alpha = 0.0001;
    transCool.updateHitbox();
    PlayState.add(transCool);

    oldCharacterBendy = PlayState.dad;

    newCharacterBendy = new Character(PlayState.dad.x - 200, PlayState.dad.y + 50, mod + ":" + "BendyNMrunDark");
    newCharacterBendy.visible = false;
	// PlayState.dad.visible = false;
    PlayState.dads.push(newCharacterBendy);
    PlayState.add(newCharacterBendy);

    // BF
    // Sets the old character as the current character.
    oldCharacterBF = PlayState.boyfriend;

    newCharacterBF = new Boyfriend(PlayState.boyfriend.x + 300, PlayState.boyfriend.y + 200, mod + ":" + "BF-NMrunDark");
    newCharacterBF.visible = false;
	// PlayState.boyfriend.visible = false;
    PlayState.boyfriends.push(newCharacterBF);
    PlayState.add(newCharacterBF);
}

function updatePost() {
	newCharacterBF.x = PlayState.boyfriend.x;
	newCharacterBF.y = PlayState.boyfriend.y;
	newCharacterBendy.x = PlayState.dad.x;
	newCharacterBendy.y = PlayState.dad.y;
}

var shutUp:Float = 0;
function update(elapsed) {
	// stage.update(elapsed);

	// PlayState.boyfriend.animation.finishCallback = function(animName:String) {
	// 	PlayState.boyfriend.playAnim(PlayState.boyfriend.animation.curAnim.name, true, false, shutUp);
	// }
	// PlayState.boyfriend.animation.curAnim.curFrame = shutUp;

	// PlayState.dad.animation.finishCallback = function(animName:String) {
	// 	PlayState.dad.playAnim(PlayState.dad.animation.curAnim.name, true, false, shutUp);
	// }
	// PlayState.dad.animation.curAnim.curFrame = shutUp;

	// yes
	if (!forcesize) {
		boyfriend.x = FlxMath.lerp(PlayState.boyfriend.x, 1040 + (PlayState.health * 100), 0.07);
		dad.x = FlxMath.lerp(PlayState.dad.x, -400 + (PlayState.health * -300), 0.07);
	}

	// defaultBrightVal = -0.20 + (health * 0.05); hmm???

	if (!overrideNMZoom) {
		if (health < 0.99) {
			defaultCamZoom = 0.85 + (health * -0.35);
			camMovement = FlxTween.tween(camFollow, {x: PlayState.boyfriend.x + 100, y: PlayState.boyfriend.y + 25}, 0.4, {ease: FlxEase.quintOut}); // bad
		} else if (health >= 1.00 && curStep >= 1)
			defaultCamZoom = 0.55;
	}
	if (!PlayState.section.mustHitSection)
		yourMOM.text = PlayState.dad.animation.curAnim.name;
	else if (PlayState.section.mustHitSection)
		yourMOM.text = PlayState.boyfriend.animation.curAnim.name;

	animationLoopingNew(PlayState.dad);
	animationLoopingNew(PlayState.boyfriend);
	animationLoopingNew(newCharacterBendy);
	animationLoopingNew(newCharacterBF);
	shutUp += elapsed * 26; // og is 26
	if (shutUp >= 11) {
		shutUp = 0;
	}
	if (FlxG.keys.justPressed.B)
		EngineSettings.botplay = !EngineSettings.botplay;
}

function animationLoopingNew(character:Character) {
	character.animation.finishCallback = function(animName:String) {
		character.playAnim(character.animation.curAnim.name, true, false, shutUp);
	}
	character.animation.curAnim.curFrame = shutUp;
}

function beatHit(curBeat) {
	// stage.onBeat();
}

function stepHit(curStep) {
	switch(curStep) {
		case 411, 539, 1303, 1659, 1930:
			switchTunnels();
	}
}
var normalBGactive = true;
var stairsActive = false;
var inkMacActive = false;
function bgLoopHandler() {
    bg.visible = true;

    var loopRNG = FlxG.random.int(1,5);
    if (normalBGactive) {
        bg.animation.play('Loop' + loopRNG);
        bg.animation.finishCallback = function(animName:String) {
            if (normalBGactive) {
                bgLoopHandler(); } 
            }
    }
    else {
        bg.animation.play('Tunnel');
        bg.animation.finishCallback = function(animName:String) {
            if (!stairsActive || !inkMacActive) {
                bgLoopHandler(); } 
        }
    }
}

function switchTunnels() {
	canPause = false;
    transCool.alpha = 1;
    normalBGactive = !normalBGactive;
    transCool.animation.play('trans');
    new FlxTimer().start(.6, function(tmr:FlxTimer) {
        bgLoopHandler();
        newCharacterBF.visible = !newCharacterBF.visible;
        newCharacterBendy.visible = !newCharacterBendy.visible;

        PlayState.boyfriend.visible = !PlayState.boyfriend.visible;
        PlayState.dad.visible = !PlayState.dad.visible;
    });
    transCool.animation.finishCallback = function(animName:String) {
        transCool.alpha = 0.0001;
		canPause = true; }
}

// not finished, will finish it when release date happens