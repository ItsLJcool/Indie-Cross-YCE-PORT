// add things
var curShootingGreenShit = false; // unused since its triggered by Alt animations
var curAttackingFire = false;
var curShootingBullets = false;
var curAttackingSaw = false;
var noMoreSaw = true;
var sawAttackingAgain = false;

var playOnce = false;
var playOnce2 = false;

var phase2Cup = false;
var canAttack = false;

var gonnaDieToMug = false;

var blueBlasting:FlxSprite;
var blueBlastingVFX:FlxSprite;
var bulletsYessir:FlxSprite;
var bulletsYessirVFX:FlxSprite;
var greenShitAttack:FlxSprite;

var attackButton:FlxSprite;
var dodgeButton:FlxSprite;

var grainShit:FlxSprite;
var rainLayer01:FlxSprite;
var rainLayer02:FlxSprite;
var dodgeAlert:FlxSprite;
var mugManFuckingDies:FlxSprite;
var aKnockout:FlxSprite;
var totallyNotGreenRoundAbout:FlxSprite;
var cardShit:FlxSprite;

function create() {
    attackButton = new FlxSprite(-30, 200);
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

    dodgeButton = new FlxSprite(-30, 300);
    dodgeButton.frames = Paths.getSparrowAtlas('cuphead/Notmobilegameanymore');
    dodgeButton.animation.addByPrefix('dodgeNormal', 'Dodge instance 1', 24, false);
    dodgeButton.animation.addByPrefix('dodgeClicked', 'Dodge click instance 1', 24, false);
    dodgeButton.animation.play('dodgeNormal');
    dodgeButton.antialiasing = EngineSettings.antialiasing;
    dodgeButton.scale.set(.5, .5);
    dodgeButton.cameras = [PlayState.camHUD];
    dodgeButton.alpha = 0.7;
    PlayState.add(dodgeButton);

    grainShit = new FlxSprite(0,0);
    grainShit.frames = Paths.getSparrowAtlas('cuphead/CUpheqdshid');
    grainShit.animation.addByPrefix('brrrrr', 'Cupheadshit_gif instance 1', 24, true);
    grainShit.animation.play('brrrrr');
    grainShit.antialiasing = EngineSettings.antialiasing;
    grainShit.cameras = [PlayState.camHUD];
    PlayState.add(grainShit);

    rainLayer01 = new FlxSprite(0,0);
    rainLayer01.frames = Paths.getSparrowAtlas('cuphead/NewRAINLayer01');
    rainLayer01.animation.addByPrefix('imWet', 'RainFirstlayer instance 1', 24, true);
    rainLayer01.animation.play('imWet');
    rainLayer01.antialiasing = EngineSettings.antialiasing;
    rainLayer01.cameras = [PlayState.camHUD];
    PlayState.add(rainLayer01);

    rainLayer02 = new FlxSprite(0,0);
    rainLayer02.frames = Paths.getSparrowAtlas('cuphead/NewRainLayer02');
    rainLayer02.animation.addByPrefix('itsCold', 'RainFirstlayer instance 1', 24, true);
    rainLayer02.animation.play('itsCold');
    rainLayer02.antialiasing = EngineSettings.antialiasing;
    rainLayer02.cameras = [PlayState.camHUD];
    PlayState.add(rainLayer02);

    if (EngineSettings.downscroll == false) {
        dodgeAlert = new FlxSprite(550,350);
        dodgeAlert.frames = Paths.getSparrowAtlas('cuphead/mozo'); }
    else {
        dodgeAlert = new FlxSprite(550,50);
        dodgeAlert.frames = Paths.getSparrowAtlas('cuphead/gay'); }
    dodgeAlert.animation.addByPrefix('dodgeBITCH', 'YTJT instance 1', 24, false);
    dodgeAlert.animation.play('dodgeBITCH');
    dodgeAlert.visible = false;
    dodgeAlert.antialiasing = EngineSettings.antialiasing;
    dodgeAlert.cameras = [PlayState.camHUD];
    PlayState.add(dodgeAlert);

    PlayState.isWidescreen = false;

    aKnockout = new FlxSprite(215, 125);
    aKnockout.frames = Paths.getSparrowAtlas('cuphead/knock');
    aKnockout.animation.addByPrefix('Knockout!', 'A KNOCKOUT!', 24, false);
    aKnockout.animation.play('Knockout!');
    aKnockout.antialiasing = EngineSettings.antialiasing;
	aKnockout.scale.set(.8, .8);
    aKnockout.updateHitbox();
    aKnockout.cameras = [PlayState.camHUD];
}

function createInFront() {
    mugManFuckingDies = new FlxSprite(1147, 473);
    mugManFuckingDies.frames = Paths.getSparrowAtlas('cuphead/Mugman Fucking dies');
    mugManFuckingDies.animation.addByPrefix('itIsGoodDayToBeNotDead', 'Mugman instance 1', 24, false);
    mugManFuckingDies.animation.addByPrefix('theMugmanIsDead??', 'MUGMANDEAD YES instance 1', 24, false); // ugh it loops even if its fasle, cringe
    mugManFuckingDies.animation.addByIndices('theMugmanIsDeadbutLastFrame', 'MUGMANDEAD YES instance 1', [8], ".png", 24, false, false, false);
    mugManFuckingDies.animation.play('itIsGoodDayToBeNotDead');
    mugManFuckingDies.antialiasing = EngineSettings.antialiasing;
    mugManFuckingDies.updateHitbox();

	cardShit = new FlxSprite(1100, 550);
	cardShit.frames = Paths.getSparrowAtlas('cuphead/cardShit/Cardcrap');
	cardShit.animation.addByPrefix('cardFilled', 'Card Filled instance 1', 24, false);
	cardShit.animation.addByPrefix('cardPopOut', 'Card Normal Pop out instance 1', 24, false);
	cardShit.animation.addByPrefix('cardUsed', 'Card Used instance 1', 24, false);
	cardShit.animation.addByPrefix('cardFlipping', 'Card but flipped instance 1', 24, false);
	cardShit.animation.addByPrefix('cardPopOutPARRY', 'PARRY Card Pop out  instance 1', 24, false);
	cardShit.animation.play('cardFilled');
	cardShit.antialiasing = EngineSettings.antialiasing;
	// cardShit.scale.set(.5, .5);
	// cardShit.screenCenter();
	cardShit.cameras = [PlayState.camHUD];
	cardShit.visible = false;
	PlayState.add(cardShit);
}

function stepHit(curStep:Int) {
    // bullets
    if (curShootingBullets && PlayState.dad.animation.curAnim.name == 'attack' && PlayState.dad.animation.curAnim.name != null) {
        var rngBulletAnim = FlxG.random.int(1, 3);
        var rngYvalBull = FlxG.random.int(230, 340);
        var rngBulletSFX = FlxG.random.int(0,5);

        bulletsYessir = new FlxSprite(250, rngYvalBull);
        bulletsYessir.frames = Paths.getSparrowAtlas('cuphead/Cupheadshoot');
        bulletsYessir.animation.addByPrefix('bulletShoot1', 'BulletFX_H-Tween_02 instance 1', 24, false);
        bulletsYessir.animation.addByPrefix('bulletShoot2', 'BulletFX_H-Tween_02 instance 2', 24, false);
        bulletsYessir.animation.addByPrefix('bulletShoot3', 'BulletFX_H-Tween_03 instance 1', 24, false);
        bulletsYessir.animation.play('bulletShoot' + rngBulletAnim);
        bulletsYessir.antialiasing = EngineSettings.antialiasing;
        bulletsYessir.scale.set(1.2, 1.2);
        bulletsYessir.updateHitbox();
        PlayState.add(bulletsYessir);
        bulletsYessir.animation.finishCallback = function(animName:String) { // you done? good now die
            bulletsYessir.destroy();
        }
        /*
        bulletsYessirVFX = new FlxSprite(280, 560);
        bulletsYessirVFX.frames = Paths.getSparrowAtlas('cuphead/Cupheadshoot');
        bulletsYessirVFX.animation.addByPrefix('bulletVFX', 'BulletFlashFX instance 1', 24, false);
        bulletsYessirVFX.animation.play('bulletVFX');
        bulletsYessirVFX.antialiasing = EngineSettings.antialiasing;
        bulletsYessirVFX.updateHitbox();
        PlayState.add(bulletsYessirVFX);
        bulletsYessirVFX.animation.finishCallback = function(animName:String) { // you done? good now die
            bulletsYessirVFX.destroy();
            PlayState.remove(bulletsYessirVFX);
        } */ // broken BRUH

        FlxG.sound.play(Paths.sound('cuphead/attacks/pea' + rngBulletSFX));
        PlayState.health -= .035;
    }

    if (curStep == 1194) {
        var opacity:{value:Float} = {value: aKnockout.alpha};
        FlxTween.tween(opacity, {value: 0}, 2.5, {ease: FlxEase.linear, onUpdate: twn -> {
            aKnockout.alpha = opacity.value; }});
    }
}

function beatHit(curBeat:Int) {
    if (curBeat == 36 || curBeat == 100 || curBeat == 125 || curBeat == 161 || curBeat == 193 || curBeat == 400) { 
        // Blasting
        curAttackingFire = true;
        PlayState.dad.playAnim('fireball');

        blueBlasting = new FlxSprite(-600, 450);
        blueBlasting.frames = Paths.getSparrowAtlas('cuphead/Cuphead Hadoken');
        blueBlasting.animation.addByPrefix('deathBlast', 'Hadolen instance 1', 24, true);
        blueBlasting.animation.play('deathBlast');
        blueBlasting.antialiasing = EngineSettings.antialiasing;
        PlayState.add(blueBlasting);
        // VFX
        blueBlastingVFX = new FlxSprite(-600, 0);
        blueBlastingVFX.frames = Paths.getSparrowAtlas('cuphead/Cuphead Hadoken');
        blueBlastingVFX.animation.addByPrefix('VFXyoo', 'BurstFX instance 1', 24, false);
        blueBlastingVFX.animation.play('VFXyoo');
        blueBlastingVFX.antialiasing = EngineSettings.antialiasing;
        PlayState.add(blueBlastingVFX);

        FlxG.sound.play(Paths.sound('cuphead/pre_shoot'));
        FlxTween.tween(blueBlasting, {x: 3000}, 3, {ease: FlxG.linear, onComplete: function() {
            PlayState.remove(blueBlasting);
        }});
        blueBlastingVFX.animation.finishCallback = function(animName:String) {
            PlayState.remove(blueBlastingVFX); }
    }
    if (curBeat == 285) {
        PlayState.add(mugManFuckingDies);
        mugManFuckingDies.animation.play('itIsGoodDayToBeNotDead');
        mugManFuckingDies.animation.finishCallback = function(animName:String) {
            mugManFuckingDies.animation.play('theMugmanIsDead??');
            FlxG.sound.play(Paths.sound('cuphead/hurt'));
            FlxG.sound.play(Paths.sound('cuphead/knockout'));
            PlayState.add(aKnockout);
            // knockout
            mugManFuckingDies.animation.finishCallback = function(animName:String) {
                mugManFuckingDies.animation.play('theMugmanIsDeadbutLastFrame'); }

        }}

    if (curBeat == 291) {
        // Blasting SPECIAL MUGMAN
        curAttackingFire = true;
        gonnaDieToMug = true;
        PlayState.dad.playAnim('fireball');

        blueBlasting = new FlxSprite(-600, 450);
        blueBlasting.frames = Paths.getSparrowAtlas('cuphead/Cuphead Hadoken');
        blueBlasting.animation.addByPrefix('deathBlast', 'Hadolen instance 1', 24, true);
        blueBlasting.animation.play('deathBlast');
        blueBlasting.antialiasing = EngineSettings.antialiasing;
        PlayState.add(blueBlasting);
        // VFX
        blueBlastingVFX = new FlxSprite(-600, 0);
        blueBlastingVFX.frames = Paths.getSparrowAtlas('cuphead/Cuphead Hadoken');
        blueBlastingVFX.animation.addByPrefix('VFXyoo', 'BurstFX instance 1', 24, false);
        blueBlastingVFX.animation.play('VFXyoo');
        blueBlastingVFX.antialiasing = EngineSettings.antialiasing;
        PlayState.add(blueBlastingVFX);

        FlxG.sound.play(Paths.sound('cuphead/pre_shoot'));
        FlxTween.tween(blueBlasting, { x: 60}, .5, {ease: FlxG.linear, onComplete: function() {
            PlayState.remove(blueBlasting);
            blueBlastingVFX = new FlxSprite(351, 27);
            blueBlastingVFX.frames = Paths.getSparrowAtlas('cuphead/Cuphead Hadoken');
            blueBlastingVFX.animation.addByPrefix('VFXyoo', 'BurstFX instance 1', 24, false);
            blueBlastingVFX.animation.play('VFXyoo');
            blueBlastingVFX.antialiasing = EngineSettings.antialiasing;
            PlayState.add(blueBlastingVFX);
            phase2Cup = true;
            blueBlastingVFX.animation.finishCallback = function(animName:String) {
                PlayState.remove(blueBlastingVFX); }
        }});
        blueBlastingVFX.animation.finishCallback = function(animName:String) {
            PlayState.remove(blueBlastingVFX); }
    }

    if (curBeat == 77 || curBeat == 115 || curBeat == 181 || curBeat == 205 || curBeat == 244 || curBeat == 320 || curBeat == 353) {
        curShootingBullets = true;
    }

    if (curBeat == 35 || curBeat == 99 || curBeat == 124 || curBeat == 149 || curBeat == 160 || curBeat == 192 || curBeat == 291 || curBeat == 227 || curBeat == 399) {
        dodgeAlert.visible = true;
        dodgeAlert.animation.play('dodgeBITCH');
        FlxG.sound.play(Paths.sound('cuphead/fuckyoumoro'));
        dodgeAlert.animation.finishCallback = function(animName:String) { // you done? good now die
           dodgeAlert.visible = false; }
    }

    if (curBeat == 150 || curBeat == 228) {
        playOnce2 = false;
        PlayState.dad.playAnim('fireball');
        curAttackingSaw = true;
        noMoreSaw = false;

        totallyNotGreenRoundAbout = new FlxSprite(163, 454);
        totallyNotGreenRoundAbout.frames = Paths.getSparrowAtlas('cuphead/Roundabout');
        totallyNotGreenRoundAbout.animation.addByPrefix('roundAboutWEEEE', 'Roundabout instance 1', 24, true);
        totallyNotGreenRoundAbout.animation.play('roundAboutWEEEE');
        totallyNotGreenRoundAbout.antialiasing = EngineSettings.antialiasing;
        totallyNotGreenRoundAbout.scale.set(1.6, 1.6);
        totallyNotGreenRoundAbout.updateHitbox();
        PlayState.add(totallyNotGreenRoundAbout);

        FlxTween.tween(totallyNotGreenRoundAbout, { x: 1450, y: 450}, 1.5, {ease: FlxEase.sineInOut, type: 1, onComplete: function() {
            FlxTween.tween(totallyNotGreenRoundAbout, { x: -1400, y: 450}, 3.5, {ease: FlxEase.quartInOut, type: 8, onComplete: function() {
                noMoreSaw = true;
            }});
        }});
    }
}

function onDadHit() {
    // greenShit
    var rngGreenShitAnim = FlxG.random.int(1, 3);
    var rngGreenChaserSFX = FlxG.random.int(0, 4);

    greenShitAttack = new FlxSprite(197, 571); // default offset
    greenShitAttack.frames = Paths.getSparrowAtlas('cuphead/GreenShit');
    greenShitAttack.animation.addByPrefix('greenBulletEWWW1', 'GreenShit01 instance 1', 24, false);
    greenShitAttack.animation.addByPrefix('greenBulletEWWW2', 'GreenShit02 instance 1', 24, false);
    greenShitAttack.animation.addByPrefix('greenBulletEWWW3', 'Greenshit03 instance 1', 24, false);
    greenShitAttack.animation.play('greenBulletEWWW' + rngGreenShitAnim);
    greenShitAttack.antialiasing = EngineSettings.antialiasing;
    greenShitAttack.updateHitbox();
    
    if (PlayState.dad.animation.curAnim.name == 'singLEFT-alt' && PlayState.dad.animation.curAnim.name != null) {
        PlayState.add(greenShitAttack);
        greenShitAttack.x = 190;
        greenShitAttack.y = 565;
        FlxG.sound.play(Paths.sound('cuphead/attacks/chaser' + rngGreenChaserSFX));
    }
    else if (PlayState.dad.animation.curAnim.name == 'singDOWN-alt' && PlayState.dad.animation.curAnim.name != null) {
        PlayState.add(greenShitAttack);
        greenShitAttack.x = 225;
        greenShitAttack.y = 560;
        FlxG.sound.play(Paths.sound('cuphead/attacks/chaser' + rngGreenChaserSFX));
    }
    else if (PlayState.dad.animation.curAnim.name == 'singUP-alt' && PlayState.dad.animation.curAnim.name != null) {
        PlayState.add(greenShitAttack);
        greenShitAttack.x = 225;
        greenShitAttack.y = 560;
        FlxG.sound.play(Paths.sound('cuphead/attacks/chaser' + rngGreenChaserSFX));
    }
    else if (PlayState.dad.animation.curAnim.name == 'singRIGHT-alt' && PlayState.dad.animation.curAnim.name != null) {
        PlayState.add(greenShitAttack);
        greenShitAttack.x = 210;
        greenShitAttack.y = 580;
        FlxG.sound.play(Paths.sound('cuphead/attacks/chaser' + rngGreenChaserSFX));
}
    greenShitAttack.animation.finishCallback = function(animName:String) { // you done? good now die
        greenShitAttack.kill();
        greenShitAttack.visible = false;
        PlayState.health -= .025; }

    if (phase2Cup) {
        phase2Cup = false;
    }
}

function onPlayerHit(note:Note) { 
	if (note.noteType == 1) {
        cardShit.y = 550;
		cardShit.visible = true;
        if (!canAttack) {
		    cardShit.animation.play('cardPopOutPARRY');
            canAttack = true; }
	}
}

function update(elapsed:Float) {
    if (!noMoreSaw) {
    var defaultY = 450;
    totallyNotGreenRoundAbout.y = defaultY + (Math.sin(Conductor.songPosition / 100) * 50); }

    if (phase2Cup && PlayState.dad.animation.curAnim.name == 'idle' && PlayState.dad.animation.curAnim.name != null) {
        PlayState.dad.playAnim('phase2');
    }

    if (curShootingBullets && PlayState.dad.animation.curAnim.name == 'idle' && PlayState.dad.animation.curAnim.name != null) {
        PlayState.dad.playAnim('attack');
    }

    if (curAttackingSaw && FlxG.keys.justPressed.SPACE || EngineSettings.botplay && curAttackingSaw) {
        if (EngineSettings.botplay) {
            new FlxTimer().start(1, function(tmr:FlxTimer) {
                if (curAttackingSaw) {
                    curAttackingSaw = false;
                    PlayState.boyfriend.playAnim('dodge');
                    }});
                }
            else {
                curAttackingSaw = false;
                PlayState.boyfriend.playAnim('dodge');
                trace('Dodge bitch');
            }
        }

    if (sawAttackingAgain && FlxG.keys.justPressed.SPACE || EngineSettings.botplay && sawAttackingAgain) {
        if (EngineSettings.botplay) {
        new FlxTimer().start(.65, function(tmr:FlxTimer) {
            if (sawAttackingAgain) {
                sawAttackingAgain = false;
                PlayState.boyfriend.playAnim('dodge');
                }});
            }
        else {
            sawAttackingAgain = false;
            PlayState.boyfriend.playAnim('dodge');
        }
    }
    
    if (canAttack && FlxG.keys.justPressed.SHIFT) {
        PlayState.dad.playAnim('hurt');
        PlayState.boyfriend.playAnim('attack');
        FlxG.sound.play(Paths.sound('cuphead/hurt'));
        canAttack = false;
		cardShit.animation.play('cardPopOut');
		FlxTween.tween(cardShit, {x: 1100, y: 900}, 1.5, {ease: FlxG.quadInOut, type: 1, onComplete: function () {
            cardShit.visible = false;
        }});
        cardShit.animation.finishCallback = function(animName:String) {
        }
        if (curShootingBullets) {
            curShootingBullets = false; }
    }

    if (curShootingBullets && FlxG.keys.justPressed.SHIFT && canAttack  || EngineSettings.botplay && curShootingBullets && canAttack ) {
        if (EngineSettings.botplay) {
            new FlxTimer().start(1, function(tmr:FlxTimer) { 
                    if (curShootingBullets) {
                    curShootingBullets = false;
                    PlayState.dad.playAnim('hurt');
                    PlayState.boyfriend.playAnim('attack');
                    FlxG.sound.play(Paths.sound('cuphead/hurt'));
                    canAttack = false;
                    cardShit.animation.play('cardPopOut');
                    FlxTween.tween(cardShit, {x: 1100, y: 900}, 1.5, {ease: FlxG.quadInOut, type: 1, onComplete: function () {
                        cardShit.visible = false;
                    }});

                    // Clicked button
                    attackButton.animation.play('attackClicked');
                    attackButton.animation.finishCallback = function(animName:String) {
                        attackButton.animation.play('attackCooldown');
                            attackButton.animation.finishCallback = function(animName:String) {
                                attackButton.animation.play('attackNormal'); } } 
                }});
            }
        else {
            curShootingBullets = false;
            PlayState.dad.playAnim('hurt');
            PlayState.boyfriend.playAnim('attack');
            FlxG.sound.play(Paths.sound('cuphead/hurt'));
            canAttack = false;
            cardShit.animation.play('cardPopOut');
            FlxTween.tween(cardShit, {x: 1100, y: 900}, 1.5, {ease: FlxG.quadInOut, type: 1, onComplete: function () {
                cardShit.visible = false;
            }});
        // Clicked button
        attackButton.animation.play('attackClicked');
        attackButton.animation.finishCallback = function(animName:String) {
            attackButton.animation.play('attackCooldown');
                attackButton.animation.finishCallback = function(animName:String) {
                    attackButton.animation.play('attackNormal'); } } 
        }
    }

    if (curAttackingFire && FlxG.keys.justPressed.SPACE || EngineSettings.botplay && curAttackingFire) {
        if (EngineSettings.botplay) {
            new FlxTimer().start(.5, function(tmr:FlxTimer) {
                if (curAttackingFire) {
                    curAttackingFire = false;
                    PlayState.boyfriend.playAnim('dodge');
                    if (gonnaDieToMug) {
                        gonnaDieToMug = false;
                    }
                    }});
            }
            else {
                curAttackingFire = false;
                PlayState.boyfriend.playAnim('dodge');
                trace('Dodge bitch');
            }
        //yo button shit
        dodgeButton.animation.play('dodgeClicked');
        dodgeButton.animation.finishCallback = function(animName:String) {
            dodgeButton.animation.play('dodgeNormal'); }
    }

    if (curAttackingFire) {
        new FlxTimer().start(.85, function(tmr:FlxTimer) {
            if (curAttackingFire) {
                curAttackingFire = false;
                PlayState.health = -1;
                if (gonnaDieToMug) {
                    Medals.unlock("Take One For The Team"); }
            }
        });
    }
    if (curAttackingSaw) {
        new FlxTimer().start(1, function(tmr:FlxTimer) {
            if (curAttackingSaw) {
                curAttackingSaw = false;
                PlayState.health = -1;
            }
    else {
        new FlxTimer().start(1, function(tmr:FlxTimer) {
        if (!playOnce2) {
            curAttackingSaw = false;
            sawAttackingAgain = true;
            playOnce2 = true; } });
            }
        });
    }
    if (sawAttackingAgain) {
        new FlxTimer().start(.9, function(tmr:FlxTimer) {
            if (sawAttackingAgain) {
                sawAttackingAgain = false;
                PlayState.health = -1;
                }
        });
    }
}

function onCountdown(val:Int) {
    var cupheadIntro:FlxSprite = new FlxSprite(0,0);
    cupheadIntro.frames = Paths.getSparrowAtlas('cuphead/the_thing2.0');
    cupheadIntro.animation.addByPrefix('intro', 'BOO instance 1', 24, false);
    cupheadIntro.animation.play('intro');
    cupheadIntro.antialiasing = EngineSettings.antialiasing;
    cupheadIntro.cameras = [PlayState.camHUD];
    cupheadIntro.animation.finishCallback = function(animName:String) {
        cupheadIntro.destroy();
    }

    var wallopIntro:FlxSprite = new FlxSprite(-300,50);
    wallopIntro.frames = Paths.getSparrowAtlas('cuphead/ready_wallop');
    wallopIntro.animation.addByPrefix('WALLOP', 'Ready? WALLOP!', 24, false);
    wallopIntro.animation.play('WALLOP');
    wallopIntro.antialiasing = EngineSettings.antialiasing;
    wallopIntro.scale.set(.7, .7);
    wallopIntro.updateHitbox();
    wallopIntro.cameras = [PlayState.camHUD];
    wallopIntro.animation.finishCallback = function(animName:String) {
        wallopIntro.destroy();
    }
    var introSFX = FlxG.random.int(0,1);

    switch(val) {
        case 3:
            PlayState.add(cupheadIntro);
            PlayState.add(wallopIntro);
            FlxG.sound.play(Paths.sound('cuphead/intros/angry/' + introSFX));
    }
    return false;
}