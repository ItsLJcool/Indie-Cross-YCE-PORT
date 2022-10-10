//a
var playerHitInks = 0;
var onlyTweenOnceUGH = false;
var inkOnScreen:Array<FlxSprite> = [];

function update(elapsed:Float) {
    if (playerHitInks >= 6) {
        PlayState.health = -1;
    }
    if (inkOnScreen[playerHitInks - 1] != null) {
        for (ink in inkOnScreen)
            ink.visible = false;
        inkOnScreen[playerHitInks - 1].visible = true;
        new FlxTimer().start(2, function(tmr:FlxTimer) {
            if (!onlyTweenOnceUGH) {
            tweenAwayInkPNG(); 
            onlyTweenOnceUGH = !onlyTweenOnceUGH; }
        });
    }  // yo holy shit thanks @BlueCario123#5925
}

function onGenerateStaticArrows() {

    for (i in 0...4) {
        var sprite = new FlxSprite().loadGraphic(Paths.image('bendy/Damage0' + (i+1)));
        sprite.cameras = [PlayState.camHUD];
        sprite.scale.set(.68,.68);
        sprite.updateHitbox();
        sprite.visible = false;
        inkOnScreen[i] = sprite;
        PlayState.add(inkOnScreen[i]);
        // yo holy shit thanks @BlueCario123#5925
    }
}

function onPlayerHit(note:Note) {
	if (note.noteType == 1) {
        onlyTweenOnceUGH = false;
        playerHitInks += 1;
        FlxG.sound.play(Paths.sound('bendy/inked'));
    }
}

function tweenAwayInkPNG() {
    for (ink in inkOnScreen) {
        var opacity:{value:Float} = {value: ink.alpha};
        FlxTween.tween(opacity, {value: 0}, 2.5, {ease: FlxEase.linear, onUpdate: twn -> {
            ink.alpha = opacity.value; }}); 
        }

    new FlxTimer().start(2.5, function(tmr:FlxTimer) {
        playerHitInks = 0;
        for (ink in inkOnScreen) {
            ink.visible = false;
            ink.alpha = 1; }
    });
}