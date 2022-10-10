//a
import('flixel.text.FlxTextBorderStyle');
var stayAsleep = false;
var boneIDLEalt = false;
var papIDLEalt = false;
var keepStomping = false;
var keepStompingMAD = false;
var papBruh = false;
var sansAwtf = false;
function createPost() {
    PlayState.scoreTxt.font = Paths.font("papyrusFont"); // YOSHI DOSN'T NEED THE .tff EXTENSION YES
    PlayState.scoreTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000);
}
function beatHit(curBeat:Int) {
        
    switch (curBeat) {
        case 63:
            stayAsleep = true;
            PlayState.dad.playAnim('papNotice', false);
        case 64:
            keepStomping = true;

        case 74:
            stayAsleep = false;
            PlayState.gf.playAnim('awakens');
        case 88:
            papIDLEalt = true;
            PlayState.dad.playAnim('lookAtSans', false);
        case 103:
            papIDLEalt = false;
        case 169:
            boneIDLEalt = true;
            PlayState.gf.playAnim('idle-alt', false);
            sansAwtf = true;
            PlayState.gf.playAnim('sansToBone');
        case 176:
            papBruh = true;
            sansAwtf = false;
        case 192:
            papBruh = false;
            keepStompingMAD = true;
            PlayState.dad.playAnim('StompingTwo', false);
        case 204:
            keepStompingMAD = false;
            boneIDLEalt = false;
            PlayState.gf.playAnim('sansToIdle');
        case 206:
            PlayState.gf.playAnim('lookAtPap');
        case 207:
            PlayState.dad.playAnim('niceOneSans', false); 
        case 308:
            PlayState.gf.playAnim('sansSleep', false);
        case 311:
            stayAsleep = true;
            papBruh = true;
            PlayState.healthBar.visible = false;
            PlayState.healthBarBG.visible = false;
            PlayState.scoreTxt.visible = false;
            PlayState.iconP1.visible = false;
            PlayState.iconP2.visible = false; 
    }
}

function stepHit(curStep:Int) {
    switch (curStep) {
        case 239:
            PlayState.gf.playAnim('sansSleep', false);
        case 282:
            keepStomping = false; }

    if (sansAwtf) {
        var papWTFdance = FlxG.random.int(1, 4);
        var prevRandom = 0;
        
        if (papWTFdance == 1) {
            PlayState.dad.playAnim('singLEFT-alt', false);
            if (prevRandom == 1) {
                PlayState.dad.playAnim('singRIGHT-alt', false); }
                prevRandom = 1; }
        else if (papWTFdance == 2) {
            PlayState.dad.playAnim('singRIGHT-alt', false); 
            if (prevRandom == 2) {
                PlayState.dad.playAnim('singUP-alt', false); }
                prevRandom = 2; }
        else if (papWTFdance == 3) {
            PlayState.dad.playAnim('singUP-alt', false); 
            if (prevRandom == 3) {
                PlayState.dad.playAnim('singDOWN-alt', false); }
                prevRandom = 3; }
        else if (papWTFdance == 4) {
            PlayState.dad.playAnim('singDOWN-alt', false); 
            if (prevRandom == 4) {
            PlayState.dad.playAnim('singLEFT-alt', false); }
            prevRandom = 4; }
        }
}

function update(elapsed:Float) {
    if (keepStomping && PlayState.dad.animation.curAnim.name == 'idle' && PlayState.dad.animation.curAnim.name != null) {
        PlayState.dad.playAnim('StompingOne', false); }

    if (keepStompingMAD && PlayState.dad.animation.curAnim.name == 'idle' && PlayState.dad.animation.curAnim.name != null) {
        PlayState.dad.playAnim('StompingTwo', false); }

    if (stayAsleep) {
        PlayState.gf.playAnim('sleeping', false); }

    if (boneIDLEalt && PlayState.gf.animation.curAnim.name == 'idle' && PlayState.gf.animation.curAnim.name != null) {
        PlayState.gf.playAnim('idle-alt', false); }

    if (papIDLEalt && PlayState.dad.animation.curAnim.name == 'idle' && PlayState.dad.animation.curAnim.name != null) {
        PlayState.dad.playAnim('lookAtSans', false); }
        
    if (papBruh) {
        PlayState.dad.playAnim('bruh', false); }
    
    if (PlayState.section.duetCamera) {
        PlayState.camFollow.x = 400; //550
        PlayState.camFollow.y = 150; //400
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