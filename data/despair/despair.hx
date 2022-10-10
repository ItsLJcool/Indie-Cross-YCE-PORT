//a
var black:FlxSprite; // fade in shit
var introName:FlxSprite;

function create() {
    
}

function createInFront() {
    black = new FlxSprite(-1000,-600).makeGraphic(FlxG.width * 6, FlxG.height * 6, 0xFF000000);
    black.scrollFactor.set();
    black.updateHitbox();
    PlayState.add(black);
}

// da end of the beginning
function onCountdown(val:Int) {
    switch(val) {
        case 3:
            introName = new FlxSprite().loadGraphic(Paths.image('bendy/introductiondespair'));
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