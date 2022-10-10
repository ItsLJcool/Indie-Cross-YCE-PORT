// code haha
import LoadingState;
import flixel.text.FlxTextBorderStyle;
import Note;
var sansBoneAtt = false;
// im dumb so here is ass code
var playOnceInUpdate = false; // oh no what would this do??
var playOnceInUpdateALT = false; // botplay Earrapes you
var playOnceInUpdateSPECIAL = false; // yes shut your mf mouth

var attackButton:FlxSprite;
var dodgeButton:FlxSprite;
var sansBoneHaha:FlxSprite;
var falseBFlol:FlxSprite;
var curBattling = false;

var allowAttack = true;

var genocideRoute = false;
var attackedTimes = 0;

// mechanics stuff
function create() {
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
    sansBoneHaha.frames = Paths.getSparrowAtlas('sans/DodgeMechs');
    sansBoneHaha.animation.addByPrefix('alarm', 'Alarm instance 1', 24, true);
    sansBoneHaha.animation.addByPrefix('attack', 'Bones boi instance 1', 24, false);
    //sansBoneHaha.animation.addByPrefix('bfDodge', 'Dodge instance 1', 24, false);
    sansBoneHaha.animation.play('alarm');
    sansBoneHaha.antialiasing = true;

    // bruh yes the coding is horrable shut the fuck up
    falseBFlol = new FlxSprite(760, 430);
    falseBFlol.frames = Paths.getSparrowAtlas('sans/DodgeMechs');
    falseBFlol.animation.addByPrefix('bfDodge', 'Dodge instance 1', 24, false);
    falseBFlol.animation.play('bfDodge');
    falseBFlol.antialiasing = true;
}

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

function createInFront() {
    // Sets the old character as the current character.
    oldCharacterSANS = PlayState.dad;

    newCharacterSANS = new Character(175, 970, mod + ":" + "SansIndieUT");
    newCharacterSANS.visible = true;
    PlayState.dads.push(newCharacterSANS);
    PlayState.add(newCharacterSANS);

    // BF
    
    // Sets the old character as the current character.
    oldCharacterBF = PlayState.boyfriend;

    newCharacterBF = new Boyfriend(100, 1690, mod + ":" + "BF-SansIC-UT");
    newCharacterBF.visible = true;
    PlayState.boyfriends.push(newCharacterBF);
    PlayState.add(newCharacterBF);
}

function stepHit(curStep:Int) {

}
EngineSettings.botplay = true;

function beatHit(curBeat:Int) {
    if (curBeat == 43 || curBeat == 75 || curBeat == 123) {
        sansBoneAtt = true;
        PlayState.add(sansBoneHaha);
        FlxG.sound.play(Paths.sound('sans/notice'));
        sansBoneHaha.animation.play('alarm');
        new FlxTimer().start(.6, function(tmr:FlxTimer) {
            sansBoneHaha.animation.play('attack');
            falseBFlol.animation.play('bfDodge');
        });
    }
    if (curBeat == 196) {
        PlayState.remove(attackButton);
        PlayState.remove(dodgeButton);
        allowAttack = false;
        if (genocideRoute) {
            curBattling = true;
        }
        else {
            notes.forEachAlive(function(flaggedNote:Note)
            {
                if (flaggedNote.noteType == 1) {
                    flaggedNote.kill();
                }
                else if (flaggedNote.noteType == 2) {
                    var newNote:Note = new Note(flaggedNote.strumTime, flaggedNote.noteData, flaggedNote.prevNote, flaggedNote.isSustainNote,
                        false);
                    newNote.mustPress = flaggedNote.mustPress;
                    if (newNote.mustPress) {
                        newNote.x += FlxG.width / 2;
                    }
                    flaggedNote.kill();
                    notes.add(newNote);
                }
            });
        }
    }
}

// Called right after the song ends.
function onPreEndSong() {
    if (genocideRoute && PlayState_.isStoryMode) {
        CoolUtil.loadSong(mod, "burning-in-hell", "hard");
        LoadingState.loadAndSwitchState(new PlayState_());
    }
    else if (!genocideRoute && PlayState_.isStoryMode) {
        CoolUtil.loadSong(mod, "final-stretch", "hard");
        LoadingState.loadAndSwitchState(new PlayState_());
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

    if (FlxG.keys.justPressed.SHIFT && allowAttack) {
        attackedTimes += 1;
        var rngSFXattack = FlxG.random.int(1,3);
        FlxG.sound.play(Paths.sound('sans/Throw' + rngSFXattack));
        PlayState.boyfriend.playAnim('attack');
        PlayState.health += .035;
        new FlxTimer().start(.3, function(tmr:FlxTimer) {
            PlayState.dad.playAnim('dodge');
            FlxG.sound.play(Paths.sound('sans/dodge'));
        });
        allowAttack = false;
        //yo button shit
        attackButton.animation.play('attackClicked');
        attackButton.animation.finishCallback = function(animName:String) {
            attackButton.animation.play('attackCooldown');
            attackButton.animation.finishCallback = function(animName:String) {
                    attackButton.animation.play('attackNormal');
                    allowAttack = true;
                }
            }
            if (attackedTimes == 3) {
            genocideRoute = true;
            FlxG.log.add('Genocide Route Enabled');
            FlxG.sound.play(Paths.sound('sans/genocide'));
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

    if (curBattling) {
        PlayState.camFollow.x = 400;
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
}

function onCountdown(val:Int) {
//    FlxG.sound.play(Paths.sound('sans/countdown'));
//    FlxG.sound.play(Paths.sound('sans/countdown finished'));
    switch(val) {
        case 3:
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