//a
var black:FlxSprite; // fade in shit
var introName:FlxSprite;
var bendyCutOutJumpscare:FlxSprite;
var bendyPopUpRNG:Int;
var bendyPopUpRNG2:Int;
var bendyPopUpRNG3:Int;
var bendyPopUpRNG4:Int;

function create() {
    PlayState.isWidescreen = false;
    bendyPopUpRNG = FlxG.random.int(212,220);
    bendyPopUpRNG2 = FlxG.random.int(276,288);
    bendyPopUpRNG3 = FlxG.random.int(336,388);
    bendyPopUpRNG4 = FlxG.random.int(448,470);
}

function createInFront() {

    bendyCutOutJumpscare = new FlxSprite(826, 325);
    bendyCutOutJumpscare.frames = Paths.getSparrowAtlas('bendy/Cutouts/BendyCutouts');
    bendyCutOutJumpscare.animation.addByPrefix('jumpscare1', '01 instance 1', 24, false); // x: 826, y: 325
    bendyCutOutJumpscare.animation.addByPrefix('jumpscare2', '02 instance 1', 24, false); // x: 250, y: 0
    bendyCutOutJumpscare.animation.addByPrefix('jumpscare3', '03 instance 1', 24, false); // x: 250, y: 0
    bendyCutOutJumpscare.animation.addByPrefix('jumpscare4', '04 instance 1', 24, false); // x: 143, y: -225
    bendyCutOutJumpscare.animation.play('jumpscare1'); // default is 1
    bendyCutOutJumpscare.antialiasing = EngineSettings.antialiasing;
    bendyCutOutJumpscare.scale.set(2,2);
    bendyCutOutJumpscare.cameras = [PlayState.camHUD];
    bendyCutOutJumpscare.visible = false;
    PlayState.add(bendyCutOutJumpscare);
}

function onGuiPopup() {
    black = new FlxSprite(-1000,-600).makeGraphic(FlxG.width * 6, FlxG.height * 6, 0xFF000000);
    black.scrollFactor.set();
    black.updateHitbox();
    PlayState.add(black);
}

function beatHit(curBeat:Int) {
    if (curBeat == bendyPopUpRNG || curBeat == bendyPopUpRNG2 || curBeat == bendyPopUpRNG3 || curBeat == bendyPopUpRNG4) {
        var jumpscareRNG = FlxG.random.int(1,4);
        bendyCutOutJumpscare.animation.play('jumpscare' + jumpscareRNG);
        bendyCutOutJumpscare.visible = true;
        switch(jumpscareRNG) {
            case 1:
                bendyCutOutJumpscare.x = 826;
                bendyCutOutJumpscare.y = 325;
            case 2:
                bendyCutOutJumpscare.x = 250;
                bendyCutOutJumpscare.y = 0;
            case 3:
                bendyCutOutJumpscare.x = 250;
                bendyCutOutJumpscare.y = 0;
            case 4:
                bendyCutOutJumpscare.x = 143;
                bendyCutOutJumpscare.y = -225;
        }
        FlxG.sound.play(Paths.sound('bendy/cutout'));
        bendyCutOutJumpscare.animation.finishCallback = function(animName:String) {
            bendyCutOutJumpscare.visible = false;
            }
    }
}

// da end of the beginning
function onCountdown(val:Int) {
    switch(val) {
        case 3:
            introName = new FlxSprite().loadGraphic(Paths.image('bendy/introductionsong2'));
            introName.scale.set(0.75,0.75);
            introName.updateHitbox();
            introName.screenCenter();
            introName.cameras = [PlayState.camHUD];
            PlayState.add(introName);
            FlxTween.tween(introName.scale, {x: 1, y: 1}, 4, {ease: FlxEase.linear});
        case 2:
            FlxG.sound.play(Paths.sound('bendy/whoosh'));
        case 1:
            // a
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

// you know bendy week is the most like talked week, bendy is a really decent week and the mecahnics make up for the lack of good songs
// even though its 'hard' its still fun to experiance and play
// fuck you bendy haters

// also terrible sin is a ok 2nd song