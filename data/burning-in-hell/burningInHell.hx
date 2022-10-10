// code haha
import("flixel.util.FlxCollision");
import('flixel.text.FlxTextBorderStyle');
var sansBoneAtt = false;
// im dumb so here is ass code
var playOnceInUpdate = false; // oh no what would this do??
var playOnceInUpdateALT = false; // botplay Earrapes you
var playOnceInUpdateSPECIAL = false; // yes shut your mf mouth

var attackButton:FlxSprite;
var dodgeButton:FlxSprite;
var sansBoneHaha:FlxSprite;
var falseBFlol:FlxSprite;
var heartRED:FlxSprite;
var gasterBlaster:FlxSprite;
var gasterBlaster2:FlxSprite; // because why not?

var heartWasHit = false;
var curBattling = false;
var allowAttack = true;
var sansAltIDLE = false;

var bfGoUp = true;
var bfGoDown = false;

var allowHeartMovement = false;
var checkTimer:Float = 0;
var checkTimer2:Float = 0;
// mechanics stuff
function createPost() {
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
function create() {
    if (save.data.hasSeenDialogue == null) {
        save.data.hasSeenDialogue = false;
        save.flush();
    }

    if (EngineSettings.botplay) {
        Window.alert("youre a pussy \n from Yoshiman29", "psych lua");
        EngineSettings.botplay = false;
        if (EngineSettings.downscroll) {
            PlayState.destroy(); // fuck downscroll players Its annoying how can you play like that eww
        }
    }
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

    // preload sans attack rq
    sansBoneHaha = new FlxSprite(520, 360);
    sansBoneHaha.frames = Paths.getSparrowAtlas('sans/Cardodge');
    sansBoneHaha.animation.addByPrefix('alarm', 'Alarm instance 1', 24, true);
    sansBoneHaha.animation.addByPrefix('attack', 'Bones boi instance 1', 24, false);
    //sansBoneHaha.animation.addByPrefix('bfDodge', 'Dodge instance 1', 24, false);
    sansBoneHaha.animation.play('alarm');
    sansBoneHaha.antialiasing = true;

    // bruh yes the coding is horrable shut the fuck up
    falseBFlol = new FlxSprite(760, 510);
    falseBFlol.frames = Paths.getSparrowAtlas('sans/Cardodge');
    falseBFlol.animation.addByPrefix('bfDodge', 'Dodge instance 1', 24, false);
    falseBFlol.animation.play('bfDodge');
    falseBFlol.antialiasing = true;
}

function createInFront() {
    oldCharacterSANS = PlayState.dad;

    newCharacterSANS = new Character(175, 970, mod + ":" + "SansIndieUT");
    newCharacterSANS.visible = true;
    PlayState.dads.push(newCharacterSANS);
    PlayState.add(newCharacterSANS);

    // BF
    // Sets the old character as the current character.
    oldCharacterBF = PlayState.boyfriend;
    newCharacterBF = new Boyfriend(100, 1690, mod + ":" + "BF-CharaColorless");
    newCharacterBF.visible = true;
    PlayState.boyfriends.push(newCharacterBF);
    PlayState.add(newCharacterBF);

    // heart lol
    heartRED = new FlxSprite(325, 1887).loadGraphic(Paths.image('sans/heart'));
    heartRED.scale.set(.5, .5);
    heartRED.alpha = 0;
    heartRED.updateHitbox();
    PlayState.add(heartRED);

    // gaster blasters:
    // Facing Right: -1400, 1500 __ 1800 || Angle: -45 __ 45
    // Facing Left: -2850, 1500 __ 1800  || Angle: -225 __ -135
    gasterBlaster = new FlxSprite(-1400, 1800); 
    gasterBlaster.frames = Paths.getSparrowAtlas('sans/Gaster_blasterss');
    gasterBlaster.animation.addByPrefix('blastMeh', 'fefe instance 1', 24, false);
    gasterBlaster.animation.play('blastMeh');
    gasterBlaster.antialiasing = true;
    gasterBlaster.scale.set(.5, .5);
    gasterBlaster.visible = false;
    gasterBlaster.updateHitbox();

    gasterBlaster2 = new FlxSprite(-1150, 1800); 
    gasterBlaster2.frames = Paths.getSparrowAtlas('sans/Gaster_blasterss');
    gasterBlaster2.animation.addByPrefix('blastMeh', 'fefe instance 1', 24, false);
    gasterBlaster2.animation.play('blastMeh');
    gasterBlaster2.antialiasing = true;
    gasterBlaster2.scale.set(.5, .5);
    gasterBlaster2.visible = false;
    gasterBlaster2.updateHitbox();
}

function musicstart() {
    // uhhhhhhhhhhhhhhhhhhhhhh i forgor :skull:
    canPause = true;
}
function stepHit(curStep:Int) {
    if (curStep == 400 || curStep == 668) { // fade in shit
        allowHeartMovement = true;
        // bf UT fade out to .5
        var opacity:{value:Float} = {value: newCharacterBF.alpha};
        FlxTween.tween(opacity, {value: 0.5}, 0.5, {ease: FlxEase.quadOut, onUpdate: twn -> {
        newCharacterBF.alpha = opacity.value; }});
        // heart fade in
        var opacity:{value:Float} = {value: heartRED.alpha};
        FlxTween.tween(opacity, {value: 1}, 0.5, {ease: FlxEase.quadOut, onUpdate: twn -> {
        heartRED.alpha = opacity.value; }});
    }
    else if (curStep == 508 || curStep == 762) { // fade out shit
        allowHeartMovement = false;
        // bf fade in to 1
        var opacity:{value:Float} = {value: newCharacterBF.alpha};
        FlxTween.tween(opacity, {value: 1}, 0.5, {ease: FlxEase.quadOut, onUpdate: twn -> {
        newCharacterBF.alpha = opacity.value; }});

        // heart fade out
        var opacity:{value:Float} = {value: heartRED.alpha};
        FlxTween.tween(opacity, {value: 0}, 0.5, {ease: FlxEase.quadOut, onUpdate: twn -> {
        heartRED.alpha = opacity.value; }});
    }
    // start blastin
    if (curStep == 405 || curStep == 432 || curStep == 458 || curStep == 480 || curStep == 675 || curStep == 700 || curStep == 726) {
        gasterBlaster.animation.play('blastMeh');
        gasterBlaster.visible = true;
        var rngLeftOrRight = FlxG.random.int(1, 2);
        var rngLeftAngle = FlxG.random.int(-35, 35);
        var rngRightAngle = FlxG.random.int(-215, -145);
        var rngAreaShooting = FlxG.random.int(1500, 1800);

        if (rngLeftOrRight == 1) { // Left
            gasterBlaster.x = -1400; // og -3150
            gasterBlaster.y = rngAreaShooting;
            gasterBlaster.angle = rngLeftAngle;
            trace('ballsLeft1');
        }
        else if (rngLeftOrRight == 2) { // Right
            gasterBlaster.x = -1150; // og -2850
            gasterBlaster.y = rngAreaShooting;
            gasterBlaster.angle = rngRightAngle;
            trace('ballsRight1'); }
            
        FlxG.sound.play(Paths.sound('sans/readygas'));
        new FlxTimer().start(1, function(tmr:FlxTimer) {
            FlxG.sound.play(Paths.sound('sans/shootgas'));
        });
        PlayState.add(gasterBlaster);
        gasterBlaster.animation.finishCallback = function(animName:String) {
            gasterBlaster.visible = false;
            gasterBlaster.x = -9999;
        }
    }

    // 2nd blasters
    if (curStep == 685 || curStep == 710 || curStep == 736) {
        gasterBlaster2.animation.play('blastMeh');
        gasterBlaster2.visible = true;
        var rngLeftOrRight2 = FlxG.random.int(1, 2);
        var rngLeftAngle2 = FlxG.random.int(-35, 35);
        var rngRightAngle2 = FlxG.random.int(-215, -145);
        var rngAreaShooting2 = FlxG.random.int(1500, 1800);

        if (rngLeftOrRight2 == 1) { // Left
            gasterBlaster2.x = -1400;
            gasterBlaster2.y = rngAreaShooting2;
            gasterBlaster2.angle = rngLeftAngle2;
            trace('ballsLeft2');
        }
        else if (rngLeftOrRight2 == 2) { // Right
            gasterBlaster2.x = -1150;
            gasterBlaster2.y = rngAreaShooting2;
            gasterBlaster2.angle = rngRightAngle2;
            trace('ballsRight2'); }
            
        FlxG.sound.play(Paths.sound('sans/readygas'));
        new FlxTimer().start(1, function(tmr:FlxTimer) {
            FlxG.sound.play(Paths.sound('sans/shootgas'));
            // If heartRED overlaps gasterBlaster, then fuck you! (this doesn't work???)
        });
        PlayState.add(gasterBlaster2);
        gasterBlaster2.animation.finishCallback = function(animName:String) {
            gasterBlaster2.visible = false;
            gasterBlaster2.x = -9999;
            }
        }
}

function beatHit(curBeat:Int) {
    if (curBeat == 40 || curBeat == 58 || curBeat == 228 || curBeat == 234 || curBeat == 257 || curBeat == 275 || curBeat == 358 || curBeat == 387 || curBeat == 393) {
        sansBoneAtt = true;
        PlayState.add(sansBoneHaha);
        FlxG.sound.play(Paths.sound('sans/notice'));
        sansBoneHaha.animation.play('alarm');
        new FlxTimer().start(.6, function(tmr:FlxTimer) {
            sansBoneHaha.animation.play('attack');
            falseBFlol.animation.play('bfDodge');
        });
    }

    if (curBeat == 94) { // one time special Switch
        new FlxTimer().start(.48, function(tmr:FlxTimer) {
            curBattling = true; // yes your 1v1'ing
            allowAttack = false; // fuck your microphone
            dodgeButton.visible = false;
            attackButton.visible = false;
        });
        PlayState.dad.playAnim('switchToUT');
    }

    if (curBeat == 288) { // YES FUCK SANS BF
        curBattling = true; // yes your 1v1'ing
        allowAttack = false; // fuck your microphone
        dodgeButton.visible = false;
        attackButton.visible = false;
    }
    else if (curBeat == 224 || curBeat == 352) { // AHHH SANS RUN
        curBattling = false; // no your not 1v1'ing
        allowAttack = true; // welcome back Microphone
        dodgeButton.visible = true;
        attackButton.visible = true;
    }

    if (curBeat >= 380) {
        sansAltIDLE = true;
    }
}

function update(elapsed:Float) {

    var defaultY = 1690;
    newCharacterBF.y = defaultY + (Math.sin(Conductor.songPosition / 220) * 20);

    if (sansBoneAtt && FlxG.keys.justPressed.SPACE || sansBoneAtt && EngineSettings.botplay) {
        playOnceInUpdate = false;
        if (EngineSettings.botplay) {
            new FlxTimer().start(.3, function(tmr:FlxTimer) {
                sansBoneAtt = false;
                if (!playOnceInUpdate) {
                    FlxG.sound.play(Paths.sound('sans/dodge'));
                    playOnceInUpdate = true;
                }
            });
                }
        else {
            sansBoneAtt = false;
            FlxG.sound.play(Paths.sound('sans/dodge'));
            }
        //yo button shit
        dodgeButton.animation.play('dodgeClicked');
        dodgeButton.animation.finishCallback = function(animName:String) {
            dodgeButton.animation.play('dodgeNormal');
            }
    }

    // YESS ENDING
    if (sansAltIDLE && PlayState.dad.animation.curAnim.name == 'idle') {
        PlayState.dad.playAnim('idle-alt');
    }

    if (FlxG.keys.justPressed.SHIFT && allowAttack) {
        var rngSFXattack = FlxG.random.int(1,3);
        FlxG.sound.play(Paths.sound('sans/Throw' + rngSFXattack));
        PlayState.boyfriend.playAnim('attack');
        PlayState.health += .035;
        new FlxTimer().start(.3, function(tmr:FlxTimer) {
            if (sansAltIDLE) {
                PlayState.dad.playAnim('dodgeTired'); }
            else {
                PlayState.dad.playAnim('dodge'); } // Not Used in the GJ Indie Cross version, but fuck you

            FlxG.sound.play(Paths.sound('sans/dodge'));
        });
        allowAttack = false;
        //yo button shit
        attackButton.animation.play('attackClicked');
        attackButton.animation.finishCallback = function(animName:String) {
            attackButton.animation.play('attackCooldown');
            attackButton.animation.finishCallback = function(animName:String) {
                    attackButton.animation.play('attackNormal');
                    if (dodgeButton.visible == true) {
                        allowAttack = true;
                    }
                }
            }
        }

    if (sansBoneAtt) {
        new FlxTimer().start(.6, function(tmr:FlxTimer) {
            if (sansBoneAtt) {
                if (!playOnceInUpdateALT) {
                    FlxG.sound.play(Paths.sound('sans/sansattack'));
                    playOnceInUpdateALT = true;
                }
                sansBoneHaha.animation.play('attack');
                PlayState.boyfriend.playAnim('boneFuck'); // haha get fucked
                new FlxTimer().start(.5, function(tmr:FlxTimer) {
                    PlayState.health = -1; // die later
                    sansBoneAtt = false;
                });
            }
            else {
                sansBoneHaha.animation.play('attack');
                PlayState.add(falseBFlol);
                if (!playOnceInUpdateALT) {
                    FlxG.sound.play(Paths.sound('sans/sansattack'));
                    playOnceInUpdateALT = true;
                }
                PlayState.boyfriend.visible = false;
                falseBFlol.animation.finishCallback = function(animName:String) {
                    PlayState.remove(falseBFlol);
                    PlayState.boyfriend.visible = true;
                    playOnceInUpdateALT = false;
                }
                sansBoneHaha.animation.finishCallback = function(animName:String) {
                    PlayState.remove(sansBoneHaha);
                }
                if (EngineSettings.botplay) {
                    PlayState.add(falseBFlol);
                }
            }
        });
    }

    // If heartRED overlaps gasterBlaster, then fuck you!
        if (checkTimer <= 0) {
            checkTimer = 0.2;
            if (!heartWasHit && FlxCollision.pixelPerfectCheck(heartRED, gasterBlaster)) {
                PlayState.health = -1;
                heartWasHit = true; }
            }
        else {
            checkTimer -= elapsed;
        }
    // 2nd one
        if (checkTimer2 <= 0) {
            checkTimer2 = 0.2;
            if (!heartWasHit && FlxCollision.pixelPerfectCheck(heartRED, gasterBlaster2)) {
                PlayState.health = -1;
                heartWasHit = true; }
            }
        else {
            checkTimer2 -= elapsed;
        }

    if (curBattling) {
        PlayState.camFollow.x = 340;
        PlayState.camFollow.y = 1800;
        if (playOnceInUpdateSPECIAL) {
        FlxG.camera.focusOn(PlayState.camFollow.getPosition());
            playOnceInUpdateSPECIAL = false;
        } 
    }
    else {
        if (!playOnceInUpdateSPECIAL) {
        PlayState.camFollow.x = 550; //550
        PlayState.camFollow.y = 400; //400
        FlxG.camera.focusOn(PlayState.camFollow.getPosition());
            playOnceInUpdateSPECIAL = true;
        }
    }

    if (allowHeartMovement) {
        if (FlxG.keys.pressed.W /*|| PlayState.controls.UP_P*/) {
            heartRED.y -= 3;
        }
        if (FlxG.keys.pressed.A /*|| PlayState.controls.LEFT_P*/) {
            heartRED.x -= 3;
        }
        if (FlxG.keys.pressed.S /*|| PlayState.controls.DOWN_P*/) {
            heartRED.y += 3;
        }
        if (FlxG.keys.pressed.D /*|| PlayState.controls.RIGHT_P*/) {
            heartRED.x += 3;
        }
    }

    if (FlxG.keys.justPressed.H) {
        trace(heartRED.x);
        trace(heartRED.y);
    }

    // if heart if trying to go past this damn wall, fuck it

    if (heartRED.y >= 2055) {
        heartRED.y = 2055; }
    if (heartRED.y <= 1683) {
        heartRED.y = 1683; }
    if (heartRED.x >= 718) {
        heartRED.x = 718; }
    if (heartRED.x <= -80) {
        heartRED.x = -80; }
}
function onCountdown(val:Int) {
//    FlxG.sound.play(Paths.sound('sans/countdown'));
//    FlxG.sound.play(Paths.sound('sans/countdown finished'));
    switch(val) {
        case 3:
            var rngSFXattack = FlxG.random.int(1,3);
            FlxG.sound.play(Paths.sound('sans/Throw' + rngSFXattack));
            PlayState.boyfriend.playAnim('attack');
            PlayState.health += .035;
            new FlxTimer().start(.3, function(tmr:FlxTimer) {
                PlayState.dad.playAnim('dodge');
                FlxG.sound.play(Paths.sound('sans/dodge'));
            });
            FlxG.sound.play(Paths.sound('sans/countdown'));
            //sprite.animation.play("3");
        case 2:
            FlxG.sound.play(Paths.sound('sans/countdown'));
            //sprite.animation.play("2");
        case 1:
            FlxG.sound.play(Paths.sound('sans/countdown'));
            //sprite.animation.play("1");
        case 0:
            FlxG.sound.play(Paths.sound('sans/countdown finish'));
            //sprite.animation.play("GO!");
        }
    return false;
}
