// code haha
import ('flixel.text.FlxTextBorderStyle');
var sansBoneAtt = false;
// im dumb so here is ass code
var playOnceInUpdate = false; // oh no what would this do??
var playOnceInUpdateALT = false; // botplay Earrapes you
var playOnceInUpdateSPECIAL = false; // yes shut your mf mouth

var attackButton:FlxSprite;
var dodgeButton:FlxSprite;
var sansBoneHaha:FlxSprite;
var falseBFlol:FlxSprite;
// mechanics stuff
function create() {
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

function stepHit(curStep:Int) { 
    if (curStep == 155) {
        PlayState.dad.playAnim('switchUT');
        new FlxTimer().start(.5, function(tmr:FlxTimer) {
            PlayState.remove(dodgeButton);
        });
    }
}

function beatHit(curBeat:Int) {
    if (curBeat == 8) {
        sansBoneAtt = true;
        PlayState.add(sansBoneHaha);
        FlxG.sound.play(Paths.sound('sans/notice'));
        sansBoneHaha.animation.play('alarm');
        new FlxTimer().start(.6, function(tmr:FlxTimer) {
            sansBoneHaha.animation.play('attack');
            falseBFlol.animation.play('bfDodge');
        });
    }
}

function update(elapsed:Float) {
    if (sansBoneAtt && FlxG.keys.justPressed.SPACE || sansBoneAtt && botplay) {
        playOnceInUpdate = false;
        if (botplay) {
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
                if (botplay) {
                    PlayState.add(falseBFlol);
                }
            }
        });
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