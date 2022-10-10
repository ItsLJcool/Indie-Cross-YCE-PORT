// finally time
var playOnceInUpdate = false;
var curAtWaterfall = false;

var black:FlxSprite;

// "Mechanics" lol
function createInFront() {
    
    oldCharacterSANS = PlayState.dad;

    newCharacterSANS = new Character(2551, 1680, mod + ":" + "sansIndieWTF");
    newCharacterSANS.visible = true;
    PlayState.dads.push(newCharacterSANS);
    PlayState.add(newCharacterSANS);

    // BF
    // Sets the old character as the current character.
    oldCharacterBF = PlayState.boyfriend;

    newCharacterBF = new Boyfriend(3400, 1704, mod + ":" + "BF-SansIC-WTF");
    newCharacterBF.visible = true;
    PlayState.boyfriends.push(newCharacterBF);
    PlayState.add(newCharacterBF);
    
    black = new FlxSprite(-300, -300).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFF000000);
    black.scrollFactor.set();
    black.updateHitbox();
    black.visible = false;
    PlayState.add(black);
}

function stepHit(curStep:Int) {

}
function beatHit(curBeat:Int) {
    if (curBeat == 191 ||curBeat == 319) {
        black.visible = true;
        FlxG.sound.play(Paths.sound('sans/countdown'));
    }
    else if (curBeat == 192 ||curBeat == 320) {
        curAtWaterfall = !curAtWaterfall;
        black.visible = false;
        FlxG.sound.play(Paths.sound('sans/countdown'));
    }
}

function update(elapsed:Float) {
    if (curAtWaterfall) {
        PlayState.camFollow.x = 3200;
        PlayState.camFollow.y = 2100;
        if (playOnceInUpdate) {
            FlxG.camera.focusOn(PlayState.camFollow.getPosition());
            playOnceInUpdate = false; } 
    }
    else {
        if (!playOnceInUpdate) {
            PlayState.camFollow.x = 550; //550
            PlayState.camFollow.y = 400; //400
            FlxG.camera.focusOn(PlayState.camFollow.getPosition());
            playOnceInUpdate = true; }
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