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
var rainLayer01:FlxSprite;
var rainLayer02:FlxSprite;
var cardShit:FlxSprite;

// holy shit re do the ass code:
// sprites
var bulletShoot:FlxSprite;
var cupheadIntro:FlxSprite;
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
var checkIfRound:Bool = false;
var canDie:Bool = false;
var mugcanhit:Bool = false;

// Floats / ints
var pewdmg:Float = 0.0475;
var cardfloat:Float = 0;
var cardbary = 0.0; // huh?
var shaderValue:Float = 0.002;
var defaultY:Int = 550;

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

    knockoutSpr = new FlxSprite();
    knockoutSpr.frames = Paths.getSparrowAtlas('cuphead/knock');
    knockoutSpr.animation.addByPrefix('start', "A KNOCKOUT!", 24, false);
    knockoutSpr.updateHitbox();
    knockoutSpr.screenCenter();
    knockoutSpr.antialiasing = FlxG.save.data.highquality;
    knockoutSpr.scrollFactor.set();
    knockoutSpr.alpha = 0.0001;
    PlayState.add(knockoutSpr);
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

function onGenerateStaticArrows() {
    mugdead = new FlxSprite(1147, 473);
    mugdead.frames = Paths.getSparrowAtlas('cuphead/Mugman Fucking dies');
    mugdead.animation.addByPrefix('Dead', 'MUGMANDEAD', 24, false);
    mugdead.animation.addByPrefix('Stroll', 'Mugman instance', 24, true);
    mugdead.animation.play('Stroll', true);
    mugdead.animation.pause();
    mugdead.updateHitbox();
    mugdead.antialiasing = EngineSettings.antialiasing;
    mugdead.x = PlayState.boyfriend.x + 500;
    mugdead.alpha = 0.0001;
    PlayState.add(mugdead);

    cupheadIntro = new FlxSprite(0,0);
    cupheadIntro.frames = Paths.getSparrowAtlas('cuphead/the_thing2.0');
    cupheadIntro.animation.addByPrefix('intro', 'BOO instance 1', 24, false);
    cupheadIntro.animation.addByIndices('blackness', 'BOO instance 1', [0], "", 24, true);
    cupheadIntro.animation.play('blackness');
    cupheadIntro.antialiasing = EngineSettings.antialiasing;
    cupheadIntro.cameras = [PlayState.camHUD];
    cupheadIntro.setGraphicSize(Std.int((FlxG.width / camHUD.zoom) * 1.1), Std.int((FlxG.height / camHUD.zoom) * 1.1));
    cupheadIntro.updateHitbox();
    cupheadIntro.screenCenter();
    PlayState.add(cupheadIntro);
}

var stepsbeforeshoot:Array<Int> = [142, 398, 501, 647, 772, 1598,603, 912,1167];
function stepHit(curStep:Int) {
    switch(curStep) {
        case 308, 722, 820, 465, 1283, 977, 1412:
            allowCupheadAttack = true;
            PlayState.dad.playAnim("attack", true);
        case 1151:
            cupheadHadoken(false, true);
        case 142, 398, 501, 647, 772, 1598:
            cupheadHadoken(false, false);
        case 603, 912:
            cupheadHadoken(true, false);
        case 138, 394, 496, 643, 768, 1594, 599, 908, 1163:
            showDodgeSign();
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
}

function onDadHit(note:Note) {

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
    cardbar.percent = cardfloat / 2;

    if (allowCupheadAttack) {
        if (cupheadShoot && PlayState.dad.animation.curAnim.name == 'attack' && PlayState.dad.animation.curAnim.name != null) {
            cupheadAttack(FlxG.random.int(230, 340));
            PlayState.dad.playAnim("attack", false);
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

    if (checkIfRound && blueBlasting != null) {
        blueBlasting.y = defaultY + (Math.sin(Conductor.songPosition / 120) * 70);
    }
    
    // checking for dodging lol

    // holy shit this code is on fire but is way better than my old code
    if (curShootingFire && !mugGonnaDie) {
        if ((controlsJust.SPACE || EngineSettings.botplay) && canDie) {
            trace('dodge');
            dodgeButton.animation.play('dodgeClicked');
            dodgeButton.animation.finishCallback = function(animName:String) {
                dodgeButton.animation.play('dodgeNormal'); }
            canDie = false; }
        if (!checkIfRound) {
            new FlxTimer().start(0.8, function(tmr:FlxTimer) {
                if (curShootingFire && !canDie) PlayState.boyfriend.playAnim('dodge', false);
                if (canDie) {
                    canDie = false;
                    PlayState.health = -1;
                    PlayState.boyfriend.playAnim('hit', false);
                    trace("-----------------"); }
                curShootingFire = false;
            });
        }
        else {
            new FlxTimer().start(1, function(tmr:FlxTimer) {
                if (curShootingFire && !canDie) {
                    PlayState.boyfriend.playAnim('dodge', false); 
                    curShootingFire = false;
                }
                if (canDie) {
                    canDie = false;
                    PlayState.health = -1;
                    PlayState.boyfriend.playAnim('hit', false);
                    trace("-----------------"); }
                curShootingFire = false;
            });
            new FlxTimer().start(8, function(tmr:FlxTimer) {
                if (curShootingFire && !canDie) {
                    PlayState.boyfriend.playAnim('dodge', false); 
                    curShootingFire = false;
                }
                if (canDie) {
                    canDie = false;
                    PlayState.health = -1;
                    PlayState.boyfriend.playAnim('hit', false);
                    trace("-----------------"); }
                curShootingFire = false;
            });
        }
    }
    else if (curShootingFire && mugGonnaDie) {
        new FlxTimer().start(2, function(tmr:FlxTimer) {
            if ((controlsJust.SPACE || EngineSettings.botplay) && canDie) {
                trace('dodge');
                dodgeButton.animation.play('dodgeClicked');
                dodgeButton.animation.finishCallback = function(animName:String) {
                    dodgeButton.animation.play('dodgeNormal'); }
                canDie = false; }
                
                new FlxTimer().start(1, function(tmr:FlxTimer) {
                if (curShootingFire && !canDie) PlayState.boyfriend.playAnim('dodge', false);
                    if (canDie) {
                        canDie = false;
                        PlayState.health = -1;
                        PlayState.boyfriend.playAnim('hit', false);
                        trace("-----------------"); }
                    curShootingFire = false;
                });
        });
    }
}

function useAttackSlot() {
	trace(cardfloat);
	if (cardfloat >= 200) {
        attackButton.animation.play('attackClicked');
        attackButton.animation.finishCallback = function(animName:String) {
            attackButton.animation.play('attackNormal'); }
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
			dad.playAnim('hurt',true , false, 0, true);
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

    var wallopIntro:FlxSprite = new FlxSprite(-300,50);
    wallopIntro.frames = Paths.getSparrowAtlas('cuphead/ready_wallop');
    wallopIntro.animation.addByPrefix('WALLOP', 'Ready? WALLOP!', 24, false);
    wallopIntro.animation.play('WALLOP');
    wallopIntro.antialiasing = EngineSettings.antialiasing;
    wallopIntro.scale.set(.7, .7);
    wallopIntro.updateHitbox();
    wallopIntro.screenCenter();
    wallopIntro.cameras = [PlayState.camHUD];
    wallopIntro.animation.finishCallback = function(animName:String) {
        wallopIntro.destroy();
    }
    var introSFX = FlxG.random.int(0,1);

    switch(val) {
        case 3:
            cupheadIntro.animation.play('intro');
            cupheadIntro.animation.finishCallback = function(animName:String) {
                cupheadIntro.destroy();
            }
            PlayState.insert(0,wallopIntro);
            FlxG.sound.play(Paths.sound('cuphead/intros/angry/' + introSFX));
    }
    return false;
}

function cupheadAttack(yValue:Int) {
    var rngBulletAnim = FlxG.random.int(1, 3);

    bulletShoot = new FlxSprite(250,yValue);
    bulletShoot.frames = Paths.getSparrowAtlas('cuphead/Cupheadshoot');
    bulletShoot.animation.addByPrefix('bulletShoot1', 'BulletFX_H-Tween_02 instance 1', 24, false);
    bulletShoot.animation.addByPrefix('bulletShoot2', 'BulletFX_H-Tween_02 instance 2', 24, false);
    bulletShoot.animation.addByPrefix('bulletShoot3', 'BulletFX_H-Tween_03 instance 1', 24, false);
    bulletShoot.animation.play('bulletShoot' + rngBulletAnim);
    bulletShoot.antialiasing = EngineSettings.antialiasing;
    bulletShoot.scale.set(1.2, 1.2);
    bulletShoot.blend = 0;
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

function cupheadHadoken(isRound:Bool, ?mugMan:Bool) {
    curShootingFire = true;
    canDie = true;
    PlayState.dad.playAnim('fireball');
    trace(isRound);
    if (isRound == null) isRound = false;
    if (mugMan == null) isRound = false;

    checkIfRound = isRound;
    mugGonnaDie = mugMan;
    
    if (mugMan) {
        mugdead.alpha = 1;
        mugdead.animation.play('Stroll', true);
        mugcanhit = true;
        FlxTween.tween(mugdead, {x: boyfriend.x + 200}, 1, {ease: FlxEase.quadInOut}); }

    if (!isRound) {
        blueBlasting = new FlxSprite(-600, 450);
        blueBlasting.frames = Paths.getSparrowAtlas('cuphead/Cuphead Hadoken');
        blueBlasting.animation.addByPrefix('deathBlast', 'Hadolen instance 1', 24, true);
        blueBlasting.animation.play('deathBlast'); }
    else {
        blueBlasting = new FlxSprite(163, 550);
        blueBlasting.frames = Paths.getSparrowAtlas('cuphead/Roundabout');
        blueBlasting.animation.addByPrefix('roundAboutWEEEE', 'Roundabout instance 1', 24, true);
        blueBlasting.animation.play('roundAboutWEEEE');
        blueBlasting.scale.set(1.6, 1.6); }

    blueBlasting.antialiasing = EngineSettings.antialiasing;
    blueBlasting.blend = 0;
    // VFX
    blueBlastingVFX = new FlxSprite(-600, 0);
    blueBlastingVFX.frames = Paths.getSparrowAtlas('cuphead/Cuphead Hadoken');
    blueBlastingVFX.animation.addByPrefix('VFXyoo', 'BurstFX instance 1', 24, false);
    blueBlastingVFX.animation.play('VFXyoo');
    blueBlastingVFX.antialiasing = EngineSettings.antialiasing;
    blueBlastingVFX.blend = 0;
    
    hadokenArrays.push(blueBlasting);
    hadokenVFXArrays.push(blueBlastingVFX);
    var lastmemberHako = hadokenArrays.length-1;
    var lastmemberVFX = hadokenVFXArrays.length-1;

    // FlxG.sound.play(Paths.sound('cuphead/pre_shoot'));
    // add the shit
    new FlxTimer().start(0.4, function(tmr:FlxTimer) {
        if (!mugMan) PlayState.add(hadokenVFXArrays[lastmemberVFX]);
        if (!isRound && !mugMan) {
        PlayState.remove(PlayState.boyfriend);
        PlayState.add(PlayState.boyfriend);
        PlayState.add(hadokenArrays[lastmemberHako]);
        FlxTween.tween(hadokenArrays[lastmemberHako], {x: 3000}, 3, {ease: FlxG.linear, onComplete: function() {
            PlayState.remove(hadokenArrays[lastmemberHako]);
        }}); }
        else if (isRound && !mugMan) {
            PlayState.insert(7, hadokenArrays[lastmemberHako]);
            FlxTween.tween(hadokenArrays[lastmemberHako], { x: 1550}, 2, {ease: FlxEase.sineInOut, type: 1, onComplete: function() {
                PlayState.remove(hadokenArrays[lastmemberHako]);
                PlayState.insert(90, hadokenArrays[lastmemberHako]);
                curShootingFire = true;
                canDie = true;
                FlxTween.tween(hadokenArrays[lastmemberHako], { x: -1400}, 3.5, {ease: FlxEase.quartInOut, type: 8, onComplete: function() {
                    PlayState.remove(hadokenArrays[lastmemberHako]);
                }});
            }});
        }
        hadokenVFXArrays[lastmemberVFX].animation.finishCallback = function(animName:String) { // you done? good now die
            PlayState.remove(hadokenVFXArrays[lastmemberVFX]);
        }
    });
    new FlxTimer().start(2, function(tmr:FlxTimer) {
        if (mugMan) {
            PlayState.add(hadokenVFXArrays[lastmemberVFX]);
            PlayState.add(hadokenArrays[lastmemberHako]);
            FlxTween.tween(hadokenArrays[lastmemberHako], {x: 200}, 0.75, {ease: FlxG.linear, onComplete: function() {
                PlayState.remove(hadokenArrays[lastmemberHako]);
                if (canDie) {
                    PlayState.health = -1;
                    Medals.unlock("Take One For The Team"); }

                mugdead.animation.play('Dead', true);
                FlxG.sound.play(Paths.sound('cuphead/hurt'));
                omgFUCKYOUAAA();
                PlayState.dad.playAnim("phase2", true);
            }});
        }
    });
}

function onPreDeath() {
    save.data.songPosition = Conductor.songPosition;
    save.flush();
    trace('saving yes');
}

function omgFUCKYOUAAA() {
    // VFX
    blueBlastingVFX = new FlxSprite(200, 0);
    blueBlastingVFX.frames = Paths.getSparrowAtlas('cuphead/Cuphead Hadoken');
    blueBlastingVFX.animation.addByPrefix('VFXyoo', 'BurstFX instance 1', 24, false);
    blueBlastingVFX.animation.play('VFXyoo');
    blueBlastingVFX.antialiasing = EngineSettings.antialiasing;
    blueBlastingVFX.blend = 0;

    hadokenVFXArrays.push(blueBlastingVFX);
    
    var lastmemberVFX02 = hadokenVFXArrays.length-1;
    PlayState.add(hadokenVFXArrays[lastmemberVFX02]);
    hadokenVFXArrays[lastmemberVFX02].animation.finishCallback = function(animName:String) { // you done? good now die
        PlayState.remove(hadokenVFXArrays[lastmemberVFX02]);
    }
    FlxG.sound.play(Paths.sound('cuphead/knockout'));
    knockoutSpr.alpha = 1;
    knockoutSpr.animation.play('start');
    new FlxTimer().start(2, function(tmr:FlxTimer) {
        FlxTween.tween(knockoutSpr, {alpha: 0}, 2.5);
    });
}
function healthTween(amt:Float) {
    healthTweenObj.cancel();
    healthTweenObj = FlxTween.num(PlayState.health, PlayState.health + amt, 0.1, {ease: FlxEase.cubeInOut}, function(v:Float) {
        PlayState.health = v;
    });
}