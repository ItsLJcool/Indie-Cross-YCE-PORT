// add things
import openfl.filters.ShaderFilter;
import flixel.ui.FlxBar;
import flixel.ui.FlxBarFillDirection;
import ModSupport;
import GameOverSubstate;

GameOverSubstate.scriptName = mod + ':gameOverScrips/CupheadDeath';
GameOverSubstate.firstDeathSFX = 'nothing:troll:';
GameOverSubstate.gameOverMusic = 'nothing:troll:';

var attackButton:FlxSprite;
var dodgeButton:FlxSprite;

var grainShit:FlxSprite;
var cardShit:FlxSprite;

// holy shit re do the ass code:
// sprites
var bulletShoot:FlxSprite;
var cardanims:FlxSprite;
var cardbar:FlxBar;
var blueBlasting:FlxSprite;
var knockoutSpr:FlxSprite;
var sign:FlxSprite;

// arrays
var bulletShootArray:Array<FlxSprite> = [];

var hadokenArrays:Array<FlxSprite> = [];
var hadokenVFXArrays:Array<FlxSprite> = [];

// bools
var cupheadShoot:Bool = true;
var allowCupheadAttack:Bool = false;
var poped:Bool = true;
var didntdoanimyet:Bool = true;
var curShootingFire:Bool = false;
var canDie:Bool = false;

// Floats / ints
var pewdmg:Float = 0.075;
var cardfloat:Float = 0;
var cardbary = 0.0; // huh?
var shaderValue:Float = 0.002;

// tweens (rarely used)
var healthTweenObj:FlxTween;
var cardtween:FlxTween;

function create() {
    healthTweenObj = FlxTween.tween(this, {}, 0);

    attackButton = new FlxSprite(6, 235);
    attackButton.frames = Paths.getSparrowAtlas('cuphead/Notmobilegameanymore');
    attackButton.animation.addByPrefix('attackNormal', 'Attack instance 1', 24, false);
    attackButton.animation.addByPrefix('attackClicked', 'Attack Click instance 1', 24, false);
    attackButton.animation.addByPrefix('attackCooldown', 'AttackNA instance 1', 24, false);
    attackButton.animation.play('attackNormal');
    attackButton.antialiasing = EngineSettings.antialiasing;
    attackButton.scale.set(.5, .5);
    attackButton.cameras = [PlayState.camHUD];
    attackButton.alpha = 0.7;
    PlayState.add(attackButton);

    dodgeButton = new FlxSprite(6, 145 + attackButton.height);
    dodgeButton.frames = Paths.getSparrowAtlas('cuphead/Notmobilegameanymore');
    dodgeButton.animation.addByPrefix('dodgeNormal', 'Dodge instance 1', 24, false);
    dodgeButton.animation.addByPrefix('dodgeClicked', 'Dodge click instance 1', 24, false);
    dodgeButton.animation.play('dodgeNormal');
    dodgeButton.antialiasing = EngineSettings.antialiasing;
    dodgeButton.scale.set(.5, .5);
    dodgeButton.cameras = [PlayState.camHUD];
    dodgeButton.alpha = 0.7;
    PlayState.add(dodgeButton);

    if (!EngineSettings.downscroll) {
        sign = new FlxSprite(550,350);
        sign.frames = Paths.getSparrowAtlas('cuphead/mozo'); }
    else {
        sign = new FlxSprite(550,50);
        sign.frames = Paths.getSparrowAtlas('cuphead/gay'); }
    sign.animation.addByPrefix('dodgeBITCH', 'YTJT instance 1', 24, false);
    sign.animation.play('dodgeBITCH');
    sign.alpha = 0.0001;
    sign.antialiasing = EngineSettings.antialiasing;
    sign.cameras = [PlayState.camHUD];
    PlayState.add(sign);

    PlayState.isWidescreen = false;

}

var shader:CustomShader;
function createPost() {
    shader = new CustomShader(mod + ":chromaticAbliteration");
    shader.shaderData.offset.value = [-shaderValue]; // 0.001 (real indiecross shit)

    PlayState.camHUD.setFilters([new ShaderFilter(shader)]);
    PlayState.camHUD.filtersEnabled = true;

    PlayState.camGame.setFilters([new ShaderFilter(shader)]);
    PlayState.camGame.filtersEnabled = true;
}

function onGuiPopup() {
    cardanims = new FlxSprite();
    cardanims.frames = Paths.getSparrowAtlas('cuphead/cardShit/Cardcrap');
    cardanims.x = PlayState.healthBarBG.x + 665;
    cardanims.y = PlayState.healthBarBG.y - 67 - (100 / 1.5) + 5;
    cardanims.animation.addByPrefix('parry', 'PARRY Card Pop out  instance 1', 24, false);
    cardanims.animation.addByPrefix('pop', "Card Normal Pop out instance 1", 24, false);
    cardanims.animation.addByPrefix('use', "Card Used instance 1", 24, false);
    cardanims.animation.play('pop', true);
    cardanims.alpha = 0.0001;
    cardanims.antialiasing = true;
    cardanims.scrollFactor.set(0, 0);
    cardanims.cameras = [PlayState.camHUD];
    PlayState.add(cardanims);

    cardbar = new FlxBar(0, 0, FlxBarFillDirection.TOP_TO_BOTTOM, 97, 144, this, 'cardfloat', 0, 200, true);
    cardbar.scrollFactor.set(0, 0);
    cardbar.x = healthBarBG.x + 670;
    cardbar.y = 0;
    cardbar.cameras = [PlayState.camHUD];
    // cardbar.screenCenter();
    cardbar.createImageEmptyBar(Paths.image('cuphead/cardShit/cardempty'), 0xFFFFFFFF);
    cardbar.createImageFilledBar(Paths.image('cuphead/cardShit/cardfull'), 0xFFFFFFFF);
    PlayState.add(cardbar);

}

function stepHit(curStep:Int) {
    switch(curStep) {
        case 40, 208, 448, 800, 1232:
            allowCupheadAttack = true;
            PlayState.dad.playAnim("shoot", true);
    }
}

function showDodgeSign() {
    sign.alpha = 1;
    sign.animation.play('dodgeBITCH');
    FlxG.sound.play(Paths.sound('cuphead/fuckyoumoro'),0.75);
    sign.animation.finishCallback = function(name:String) {
    FlxTween.tween(sign, {alpha: 0}, 0.25, {ease: FlxEase.sineInOut});
    }
}

function beatHit(curBeat:Int) {
    if (EngineSettings.botplay && allowCupheadAttack) useAttackSlot();
	
	if (curBeat % 48 == 0) {
		cupheadHadoken();
	}
}

function onDadHit(note:Note) {
	FlxG.camera.shake(0.015, 0.1);
	PlayState.camHUD.shake(0.005, 0.1);
}

function onPlayerHit(note:Note) {
	if (note.noteType == 1) {
            meterUpdate();
	}
    if (cardfloat <= 200)
        cardtweening(1.75);
    else {
    if (poped) {
        trace('played pop anim');
        poped = false;
        cardanims.animation.play('pop');
        cardanims.alpha = 1;
        cardbar.alpha = 0.001;
        meterUpdate();
        }
    }
}

function meterUpdate() {
    didntdoanimyet = false;
    cardbar.alpha = 0.0001;
    cardanims.alpha = 1;
    cardanims.animation.play('parry', true);
    cardfloat = 200;
}

function cardtweening(amt:Float) {
	if (cardtween != null)
		cardtween.cancel();
	cardtween = FlxTween.num(cardfloat, cardfloat + amt, 0.001, {ease: FlxEase.cubeInOut}, function(v:Float) {
		cardfloat = v;
	});
}

// keys cool
var controls = FlxG.keys.pressed;
var controlsJust = FlxG.keys.justPressed;
var controlsJustNUM = FlxControls.anyJustPressed;
var controlsNUM = FlxControls.anyPressed;

function update(elapsed:Float) {
    cardbar.percent = cardfloat;

    if (allowCupheadAttack) {
        if (cupheadShoot && PlayState.dad.animation.curAnim.name == 'shoot' && PlayState.dad.animation.curAnim.name != null) {
            cupheadAttack();
            PlayState.dad.playAnim("shoot", false);
            cupheadShoot = false;
            new FlxTimer().start(0.15, function(tmr:FlxTimer) {
                cupheadShoot = true;
            }); }
    }
    if (controlsJust.SHIFT) useAttackSlot();

    if (cardbar != null && cardanims != null) {
        if (!poped || cardfloat == 200) {
            cardbar.alpha = 0.0001;
            cardanims.alpha = 1;
        }
        cardbar.y = cardbary + healthBarBG.y + 40 - (cardfloat / 1.5);
        if (cardanims.animation.curAnim.name == 'parry') {
            cardfloat = 200;
        }
    }
    if (cardfloat >= 200)
        cardfloat = 200;
    
    // checking for dodging lol

    // holy shit this code is on fire but is way better than my old code
    if (curShootingFire) {
        if (controlsJust.SPACE || EngineSettings.botplay) {
    	trace('dodge');
        canDie = false; }
        new FlxTimer().start(0.8, function(tmr:FlxTimer) {
            if (curShootingFire && !canDie) PlayState.boyfriend.playAnim('dodge', false);
            if (canDie) {
                canDie = false;
                PlayState.health -= 0.25;
                PlayState.boyfriend.playAnim('hit', false);
                trace("-----------------"); }
            curShootingFire = false;
        });
    }
}

function useAttackSlot() {
	trace(cardfloat);
	if (cardfloat >= 200) {
		canheal = true;	 // uh ill find a way to make this work but shup up for now
		cardfloat = 0;
		poped = true;
		cardanims.animation.play('use', true);
		cupheadPewMode = false;
		pewdmgScale = 1.0;
		cardanims.animation.finishCallback = function(use) {
			didntdoanimyet = true;
			cardbar.alpha = 1;
			if (cardfloat < 200)
				cardanims.alpha = 0.0001;
		}
		new FlxTimer().start(0.3, function(tmr:FlxTimer) {
            trace('chromatic effect');
            allowCupheadAttack = false;
			dad.playAnim('dodge',true , false, 0, true);
			FlxG.sound.play(Paths.sound('cuphead/hurt'), 0.5);
			// healthChange(0.5);
			pewhits = 0;
			pewdmg = 0.0225;
            PlayState.health += 0.5;
		});
		boyfriend.playAnim('attack');
		boyfriend.playAnim('attack', true, false, 0, true);
		FlxG.sound.play(Paths.sound('sans/Throw' + FlxG.random.int(1, 3)));
		boyfriend.animation.finishCallback = function(attack) {
			boyfriend.playAnim('idle', true);
		}
	}
}

function onCountdown(val:Int) {
    var introSFX = FlxG.random.int(0,1);

    switch(val) {
        case 3:
            FlxG.sound.play(Paths.sound('cuphead/intros/angry/' + introSFX));
    }
    return false;
}

function cupheadAttack() {
    var rngBulletAnim = FlxG.random.int(1, 5);

    bulletShoot = new FlxSprite(420, 520);
    bulletShoot.frames = Paths.getSparrowAtlas('cuphead/NMcupheadBull');
    bulletShoot.animation.addByPrefix('bulletShoot1', 'Shot01 instance 1', 24, false);
    bulletShoot.animation.addByPrefix('bulletShoot2', 'Shot02 instance 1', 24, false);
    bulletShoot.animation.addByPrefix('bulletShoot3', 'Shot03 instance 1', 24, false);
    bulletShoot.animation.addByPrefix('bulletShoot4', 'Shot04 instance 1', 24, false);
    bulletShoot.animation.addByPrefix('bulletShoot5', 'Shot05 instance 1', 24, false);
    bulletShoot.animation.play('bulletShoot' + rngBulletAnim);
    bulletShoot.antialiasing = EngineSettings.antialiasing;
    bulletShoot.scale.set(1.2, 1.2);
    bulletShoot.updateHitbox();

    // add the damn bullets into the array
    bulletShootArray.push(bulletShoot);
    // bacically says what it does
    var lastMember = bulletShootArray.length-1;
    // why Playstate LJ? its only 2.1.1
    // well thanks for asking myself, because support for Older versions :troll:
    PlayState.add(bulletShootArray[lastMember]);
    FlxG.sound.play(Paths.sound('cuphead/attacks/pea' + FlxG.random.int(0, 5)), 0.6);
    healthTween(-pewdmg);

    bulletShootArray[lastMember].animation.finishCallback = function(animName:String) { // you done? good now die
        PlayState.remove(bulletShootArray[lastMember]);
    }
}

function cupheadHadoken() {
    curShootingFire = true;
    canDie = true;
    PlayState.dad.playAnim('attack');

    blueBlasting = new FlxSprite(-600, 450);
	blueBlasting.frames = Paths.getSparrowAtlas('cuphead/NMcupheadAttacks');
    blueBlasting.animation.addByPrefix('deathBlast', 'DeathBlast instance 1', 24, true);
    blueBlasting.animation.play('deathBlast');
    blueBlasting.antialiasing = EngineSettings.antialiasing;
    
    hadokenArrays.push(blueBlasting);
    var lastmemberHako = hadokenArrays.length-1;

    FlxG.sound.play(Paths.sound('cuphead/pre_shoot'),1);
    // add the shit
    new FlxTimer().start(0.4, function(tmr:FlxTimer) {
        PlayState.add(hadokenArrays[lastmemberHako]);
        FlxTween.tween(hadokenArrays[lastmemberHako], {x: 3000}, 3, {ease: FlxG.linear, onComplete: function() {
            PlayState.remove(hadokenArrays[lastmemberHako]);
			}
    	});
    });
}

function onPreDeath() {
    save.data.songPosition = Conductor.songPosition;
    save.flush();
    trace('saving yes');
}

function healthTween(amt:Float) {
    healthTweenObj.cancel();
    healthTweenObj = FlxTween.num(PlayState.health, PlayState.health + amt, 0.1, {ease: FlxEase.cubeInOut}, function(v:Float) {
        PlayState.health = v;
    });
}