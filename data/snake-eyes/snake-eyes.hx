function onCountdown(val:Int) {
    var cupheadIntro:FlxSprite = new FlxSprite(0,0);
    cupheadIntro.frames = Paths.getSparrowAtlas('cuphead/the_thing2.0');
    cupheadIntro.animation.addByPrefix('intro', 'BOO instance 1', 24, false);
    cupheadIntro.animation.play('intro');
    cupheadIntro.antialiasing = EngineSettings.antialiasing;
    cupheadIntro.cameras = [PlayState.camHUD];
    cupheadIntro.animation.finishCallback = function(animName:String) {
        cupheadIntro.destroy();
    }

    var wallopIntro:FlxSprite = new FlxSprite(-300,50);
    wallopIntro.frames = Paths.getSparrowAtlas('cuphead/ready_wallop');
    wallopIntro.animation.addByPrefix('WALLOP', 'Ready? WALLOP!', 24, false);
    wallopIntro.animation.play('WALLOP');
    wallopIntro.antialiasing = EngineSettings.antialiasing;
    wallopIntro.scale.set(.7, .7);
    wallopIntro.updateHitbox();
    wallopIntro.cameras = [PlayState.camHUD];
    wallopIntro.animation.finishCallback = function(animName:String) {
        wallopIntro.destroy();
    }
    var introSFX = FlxG.random.int(0,4);

    switch(val) {
        case 3:
            PlayState.add(cupheadIntro);
            PlayState.add(wallopIntro);
            FlxG.sound.play(Paths.sound('cuphead/intros/normal/' + introSFX));
    }
    return false;
}