//a
var black:FlxSprite; // fade in shit
var introName:FlxSprite;
var healthTweenObj:FlxTween;

function create() {
    
	healthTweenObj = FlxTween.tween(this, {}, 0);

    EngineSettings.botplay = true;
    PlayState.isWidescreen = false;
}

function createPost() {
}

function createInFront() {
    black = new FlxSprite(-1000,-600).makeGraphic(FlxG.width * 6, FlxG.height * 6, 0xFF000000);
    black.scrollFactor.set();
    black.updateHitbox();
    PlayState.add(black);
    
    oldCharacterBendy = PlayState.dad;

    newCharacterBendy = new Character(PlayState.dad.x, PlayState.dad.y, mod + ":" + "BendyNMrunDark");
    newCharacterBendy.visible = false;
    PlayState.dads.push(newCharacterBendy);
    PlayState.add(newCharacterBendy);

    // BF
    // Sets the old character as the current character.
    oldCharacterBF = PlayState.boyfriend;

    newCharacterBF = new Boyfriend(PlayState.boyfriend.x, PlayState.boyfriend.y, mod + ":" + "BF-NMrunDark");
    newCharacterBF.visible = false;
    PlayState.boyfriends.push(newCharacterBF);
    PlayState.add(newCharacterBF);
}
function update() {
    //dad
    newCharacterBendy.x =  PlayState.dad.x;
    newCharacterBendy.y =  PlayState.dad.y;
    //Bf
    newCharacterBF.x =  PlayState.boyfriend.x;
    newCharacterBF.y =  PlayState.boyfriend.y;

    // PlayState.boyfriend.x = FlxMath.lerp(PlayState.boyfriend.x, 1040 + (PlayState.health * 100), 0.07);
    // PlayState.dad.x = FlxMath.lerp(PlayState.dad.x, -400 + (PlayState.health * -300), 0.07);

}
/*
stairsOff = (stairsss.width - (PlayState.dad.y-stairsss.y))* -1210 / stairsss.width;
PlayState.dad.y = stairsss.y + -stairsOff;
stairsOff = (stairsss.width - (PlayState.boyfriend.y-stairsss.y))* -1769 / stairsss.width;
PlayState.boyfriend.y = -1210 + stairsss.y + -stairsOff; */

// da end of the beginning
function onCountdown(val:Int) {
    switch(val) {
        case 3:
            introName = new FlxSprite().loadGraphic(Paths.image('bendy/introductionsong4'));
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

function onDadHit(note:Note) {
    if (healthBar.percent > 19.95 && !note.isSustainNote) healthTween(-0.05);
}

function healthTween(amt:Float) {
    healthTweenObj.cancel();
    healthTweenObj = FlxTween.num(health, health + amt, 0.1, {ease: FlxEase.cubeInOut}, function(v:Float)
    {
        health = v;
    });
}