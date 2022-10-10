//a
var black:FlxSprite; // fade in shit
var introName:FlxSprite;
var ready:FlxSprite;
var set:FlxSprite;
var go:FlxSprite;
var bouncyBois:FlxSprite;
var inkRain:FlxSprite;
//button yo
var attackButton:FlxSprite;
var dodgeButton:FlxSprite;

var allowAttack = true;
var inkShitLoop = true;

var dodgedJustNow = false;
var piperBeenHit = 0;
var piperIsAlive = false;
var piperCanAttack = true;
var strikerBeenHit = 0;
var strikerIsAlive = false;
var strikerCanAttack = true;

var noMoreBucherGang = false;


function create() {
    PlayState.isWidescreen = false;
    attackButton = new FlxSprite(-30, 200);
    attackButton.frames = Paths.getSparrowAtlas('cuphead/Notmobilegameanymore');
    attackButton.animation.addByPrefix('attackNormal', 'Attack instance 1', 24, false);
    attackButton.animation.addByPrefix('attackClicked', 'Attack Click instance 1', 24, false);
    attackButton.animation.addByPrefix('attackCooldown', 'AttackNA instance 1', 24, false);
    attackButton.animation.play('attackNormal');
    attackButton.antialiasing = true;
    attackButton.scale.set(.5, .5);
    attackButton.cameras = [PlayState.camHUD];
    PlayState.add(attackButton);

    dodgeButton = new FlxSprite(-30, 300);
    dodgeButton.frames = Paths.getSparrowAtlas('cuphead/Notmobilegameanymore');
    dodgeButton.animation.addByPrefix('dodgeNormal', 'Dodge instance 1', 24, false);
    dodgeButton.animation.addByPrefix('dodgeClicked', 'Dodge click instance 1', 24, false);
    dodgeButton.animation.play('dodgeNormal');
    dodgeButton.antialiasing = true;
    dodgeButton.scale.set(.5, .5);
    dodgeButton.cameras = [PlayState.camHUD];
    PlayState.add(dodgeButton);
}

function createInFront() {
    ready = new FlxSprite(400,-50).loadGraphic(Paths.image('bendy/ready'));
    ready.cameras = [PlayState.camHUD];
    ready.visible = false;
    ready.updateHitbox();
    PlayState.add(ready);
    
    set = new FlxSprite(425,-50).loadGraphic(Paths.image('bendy/set'));
    set.cameras = [PlayState.camHUD];
    set.visible = false;
    set.updateHitbox();
    PlayState.add(set);
    
    go = new FlxSprite(450,-50).loadGraphic(Paths.image('bendy/go'));
    go.cameras = [PlayState.camHUD];
    go.visible = false;
    go.updateHitbox();
    PlayState.add(go);
    
    // The Bucher Gang
    // THE GANG IS HERE
    tbgPiper = new FlxSprite(1085, 280); 
    tbgPiper.frames = Paths.getSparrowAtlas('bendy/third/Piper');
    tbgPiper.animation.addByPrefix('swingPiper', 'PeepAttack instance 1', 24, false);     // x: 900, y: 50
    tbgPiper.animation.addByPrefix('getReadyPiper', 'PipAttack instance 1', 24, false);   // x: 1162, y: 274 
    tbgPiper.animation.addByPrefix('*PiperDies*', 'Piper ded instance 1', 24, false);     // x: 1155, y: 120
    tbgPiper.animation.addByPrefix('owwiePiper', 'Piper gets Hit instance 1', 24, false); // x: 1155, y: 120
    tbgPiper.animation.addByPrefix('idlePiper', 'Piperr instance 1', 24, true);          // x: 1220, y: 280
    tbgPiper.animation.addByPrefix("PiperWalkin'Here", 'pip walk instance 1', 24, true); // x: 1085, y: 280
    tbgPiper.animation.play("PiperWalkin'Here");
    tbgPiper.antialiasing = EngineSettings.antialiasing;
    tbgPiper.scale.set(2,2);
    tbgPiper.updateHitbox();
    tbgPiper.visible = false;
    PlayState.add(tbgPiper);
    
    tbgStriker = new FlxSprite(-2240, 465); 
    tbgStriker.frames = Paths.getSparrowAtlas('bendy/third/Striker');
    tbgStriker.animation.addByPrefix('swingStriker', 'regeg instance 1', 24, false);                      // x: 273, y: 365
    tbgStriker.animation.addByPrefix('getReadyStriker', 'PunchAttack_container instance 1', 24, false);   // x: 273, y: 365
    tbgStriker.animation.addByPrefix('*StrikerDies*', 'I ded instance 1', 24, false);                     // x: 273, y: 365
    tbgStriker.animation.addByPrefix('owwieStriker', 'Sticker  instance 1', 24, false);                   // x: 120, y: 285
    tbgStriker.animation.addByPrefix('idleStriker', 'strrr instance 1', 24, true);                       // x: 288, y: 375
    tbgStriker.animation.addByPrefix("StrikerWalkin'Here", 'Str walk instance 1', 24, true);             // x: 226, y: 375
    tbgStriker.animation.play("StrikerWalkin'Here");
    tbgStriker.antialiasing = EngineSettings.antialiasing;
    tbgStriker.scale.set(2,2);
    tbgStriker.updateHitbox();
    tbgStriker.visible = false;
    PlayState.add(tbgStriker);

    // boncy bois
    bouncyBois = new FlxSprite(-2240, 465); 
    bouncyBois.frames = Paths.getSparrowAtlas('bendy/third/Butchergang_Bg');
    bouncyBois.animation.addByPrefix('bounceInstance', 'Symbol 1 instance 1', 24, true); // instance instance instance 1
    bouncyBois.animation.play('bounceInstance');
    bouncyBois.antialiasing = EngineSettings.antialiasing;
    bouncyBois.scale.set(3.9, 3.9);
    bouncyBois.updateHitbox();
    PlayState.add(bouncyBois);

    inkRain = new FlxSprite(0,0);
    inkRain.frames = Paths.getSparrowAtlas('bendy/third/InkRain');
    inkRain.animation.addByPrefix('rain', 'erteyd instance 1', 24, true);
    inkRain.animation.play('rain');
    inkRain.antialiasing = EngineSettings.antialiasing;
    //inkRain.scale.set(.5, .5);
    inkRain.visible = false;
    inkRain.alpha = 0;
    inkRain.cameras = [PlayState.camHUD];
    inkRain.screenCenter();
    PlayState.add(inkRain);
}

function onGuiPopup() {
    black = new FlxSprite(-1000,-600).makeGraphic(FlxG.width * 6, FlxG.height * 6, 0xFF000000);
    black.scrollFactor.set();
    black.updateHitbox();
    PlayState.add(black);
}

function beatHit(curBeat:Int) {
    switch (curBeat) {

        case 22:
            piperSpawn();
        case 44:
            strikerSpawn();

        case 28:
            PlayState.dad.playAnim('Scream');

        case 416:
            forceAllDeath();
            PlayState.dad.playAnim('Scream');

        // countdown yay
        case 445:
            countdownStolenCodeTween(ready);
        case 446:
            countdownStolenCodeTween(set);
        case 447:
            countdownStolenCodeTween(go);
        // uh
        case 469:
            inkShitLoop = false;
            for (ink in inkShitArray) {
                var opacity:{value:Float} = {value: ink.alpha};
                FlxTween.tween(opacity, {value: 0}, 2.5, {ease: FlxEase.linear, onUpdate: twn -> {
                    ink.alpha = opacity.value;
                    ink.visible = false; }}); 
                }
    }
}
// da end of the beginning
function onCountdown(val:Int) {    
    switch(val) {
        case 3:
            introName = new FlxSprite().loadGraphic(Paths.image('bendy/introductionsong3'));
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

function countdownStolenCodeTween(spriteName:FlxSprite) {
    spriteName.visible = true;
    FlxTween.tween(spriteName, {y: spriteName.y += 100, alpha: 0}, Conductor.crochet / 1000, { ease: FlxEase.cubeInOut, onComplete: function(twn:FlxTween) {
        spriteName.visible = false; }});
}

// BOIS IS TIME FOR THE MECHANICS WHOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
function update(elapsed:Float) {
    if (FlxG.keys.justPressed.SPACE) {
        dodgedJustNow = true;
        PlayState.boyfriend.playAnim('dodge');
        PlayState.boyfriend.animation.finishCallback = function(animName:String) {
            PlayState.boyfriend.playAnim('idle');
            dodgedJustNow = false;
            }
        
        //yo button shit
        dodgeButton.animation.play('dodgeClicked');
        dodgeButton.animation.finishCallback = function(animName:String) {
            dodgeButton.animation.play('dodgeNormal');
            }
    }
    if (FlxG.keys.justPressed.X && allowAttack) {
        allowAttack = false;
        PlayState.boyfriend.playAnim('attackRIGHT');
        // allowed to attack anytime, but don't play animations for something that can't be touched
        // can't touch this (duuun dun dun dun, duuuuun dun) can't touch this
        if (piperIsAlive) {
            piperJustHit(); }

        //yo button shit
        attackButton.animation.play('attackClicked');
        attackButton.animation.finishCallback = function(animName:String) {
            attackButton.animation.play('attackCooldown');
            attackButton.animation.finishCallback = function(animName:String) {
                    attackButton.animation.play('attackNormal');
                    allowAttack = true; } 
                }
        }
    
    if (FlxG.keys.justPressed.SHIFT && allowAttack) {
        allowAttack = false;
        PlayState.boyfriend.playAnim('attackLEFT');
        // allowed to attack anytime, but don't play animations for something that can't be touched
        // can't touch this (duuun dun dun dun, duuuuun dun) can't touch this
        if (strikerIsAlive) {
            strikerJustHit(); }
            
        //yo button shit
        attackButton.animation.play('attackClicked');
        attackButton.animation.finishCallback = function(animName:String) {
            attackButton.animation.play('attackCooldown');
            attackButton.animation.finishCallback = function(animName:String) {
                    attackButton.animation.play('attackNormal');
                    allowAttack = true; } 
                }
        }
    if (piperBeenHit >= 3) {
        piperBeenHit = 0;
        piperOnDeath(); }

        
    if (strikerBeenHit >= 3) {
        strikerBeenHit = 0;
        strikerOnDeath(); }

}

function dodgeHandler() {
    if (!dodgedJustNow) {
        var rngSFXhit = FlxG.random.int(1,3);
        PlayState.boyfriend.playAnim('ouch');
        FlxG.sound.play(Paths.sound('bendy/butcherSounds/Hit0' + rngSFXhit));
        PlayState.health -= 0.25;
    }
}

function piperSpawn() {
    if (!noMoreBucherGang) { // ugh code
    tbgPiper.visible = true;
    tbgPiper.animation.play("PiperWalkin'Here");
    // make sure the offset is correct
    tbgPiper.x = 1685;
    tbgPiper.y = 280;
    FlxTween.tween(tbgPiper, {x: 1085}, 3, {ease: FlxEase.linear, onComplete: function(twn:FlxTween) {
        if (!noMoreBucherGang) { // ugh code
            piperAttack(); }
        }});
    }
}

function piperAttack() {
    var rngSFXattack = FlxG.random.int(1,4); // yes its copied exactly from burningInHell
    piperIsAlive = true;
    piperCanAttack = true;
    tbgPiper.animation.play("getReadyPiper");
    tbgPiper.x = 1162;
    tbgPiper.y = 274;
    tbgPiper.animation.finishCallback = function(animName:String) {
        tbgPiper.animation.play("swingPiper");
        if (!dodgedJustNow) {
        FlxG.sound.play(Paths.sound('bendy/butcherSounds/Hurt0' + rngSFXattack)); }
        dodgeHandler();
        
        tbgPiper.x = 900;
        tbgPiper.y = 50;
            tbgPiper.animation.finishCallback = function(animName:String) {
                tbgPiper.animation.play("idlePiper");
                tbgPiper.x = 1220;
                tbgPiper.y = 280;
            }
        }
}

function piperJustHit() { // HURT CODE I FORGOR
    var rngSFXhurt = FlxG.random.int(1,2);
    piperBeenHit += 1;
    tbgPiper.animation.play("owwiePiper");
    FlxG.sound.play(Paths.sound('bendy/butcherSounds/Attack0' + rngSFXhurt));
    tbgPiper.x = 1155;
    tbgPiper.y = 120;
    tbgPiper.animation.finishCallback = function(animName:String) {
        tbgPiper.animation.play("idlePiper");
        tbgPiper.x = 1220;
        tbgPiper.y = 280;
    }
    new FlxTimer().start(3.5, function(tmr:FlxTimer) {
        if (piperCanAttack) {
        piperAttack(); }
    });
}

function piperOnDeath() {
    tbgPiper.animation.play("*PiperDies*");
    FlxG.sound.play(Paths.sound('bendy/butcherSounds/Ded'));
    piperIsAlive = false;
    piperCanAttack = false;
    tbgPiper.animation.finishCallback = function(animName:String) {
        tbgPiper.visible = false;
    };
    tbgPiper.x = 1155;
    tbgPiper.y = 120;
    new FlxTimer().start(7.5, function(tmr:FlxTimer) {
        piperSpawn();
    });
}
function strikerSpawn() {
    if (!noMoreBucherGang) { // ugh code
    tbgStriker.visible = true;
    tbgStriker.animation.play("StrikerWalkin'Here");
    // make sure the offset is correct
    tbgStriker.x = -1500;
    tbgStriker.y = 375;
    FlxTween.tween(tbgStriker, {x: 226}, 4, {ease: FlxEase.linear, onComplete: function(twn:FlxTween) {
        if (!noMoreBucherGang) { // ugh code
            strikerAttack(); }
        }});
    }
}

function strikerAttack() {
    var rngSFXattack = FlxG.random.int(1,4); // yes its copied exactly from burningInHell
    strikerIsAlive = true;
    strikerCanAttack = true;
    tbgStriker.animation.play("getReadyStriker");
    tbgStriker.x = 273;
    tbgStriker.y = 365;
    tbgStriker.animation.finishCallback = function(animName:String) {
        tbgStriker.animation.play("swingStriker");
        if (!dodgedJustNow) {
        FlxG.sound.play(Paths.sound('bendy/butcherSounds/Hurt0' + rngSFXattack)); }
        dodgeHandler();
        
        tbgStriker.x = 273;
        tbgStriker.y = 365;
            tbgStriker.animation.finishCallback = function(animName:String) {
                tbgStriker.animation.play("idleStriker");
                tbgStriker.x = 288;
                tbgStriker.y = 375;
            }
        }
}

function strikerJustHit() { // HURT CODE I FORGOR
    var rngSFXhurt = FlxG.random.int(1,2);
    strikerBeenHit += 1;
    tbgStriker.animation.play("owwieStriker");
    FlxG.sound.play(Paths.sound('bendy/butcherSounds/Attack0' + rngSFXhurt));
    tbgStriker.x = 120;
    tbgStriker.y = 285;
    tbgStriker.animation.finishCallback = function(animName:String) {
        tbgStriker.animation.play("idleStriker");
        tbgStriker.x = 288;
        tbgStriker.y = 375;
    }
    new FlxTimer().start(3.5, function(tmr:FlxTimer) {
        if (strikerCanAttack) {
        strikerAttack(); }
    });
}

function strikerOnDeath() {
    tbgStriker.animation.play("*StrikerDies*");
    FlxG.sound.play(Paths.sound('bendy/butcherSounds/ded'));
    strikerIsAlive = false;
    strikerCanAttack = false;
    tbgStriker.animation.finishCallback = function(animName:String) {
        tbgStriker.visible = false;
    };
    tbgStriker.x = 273;
    tbgStriker.y = 365;
    new FlxTimer().start(7.5, function(tmr:FlxTimer) {
        strikerSpawn();
    });
}

function forceAllDeath() {
    // piper
    piperCanAttack = false;
    tbgPiper.animation.play("*PiperDies*");
    FlxG.sound.play(Paths.sound('bendy/butcherSounds/Ded'));
    piperIsAlive = false;
    tbgPiper.animation.finishCallback = function(animName:String) {
        tbgPiper.visible = false;
    };
    tbgPiper.x = 1155;
    tbgPiper.y = 120;

    // striker
    strikerCanAttack = false;
    tbgStriker.animation.play("*StrikerDies*");
    FlxG.sound.play(Paths.sound('bendy/butcherSounds/Ded'));
    strikerIsAlive = false;
    tbgStriker.animation.finishCallback = function(animName:String) {
        tbgStriker.visible = false;
    };
    tbgStriker.x = 273;
    tbgStriker.y = 365;

    noMoreBucherGang = true;
}