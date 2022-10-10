var stage:Stage = null;
function create() {
	stage = loadStage('cupheadRain');
}
function onGenerateStaticArrows() {
	fgStatic = new FlxSprite();
	fgStatic.frames = Paths.getSparrowAtlas('cuphead/CUpheqdshid');
	fgStatic.animation.addByPrefix('play', 'Cupheadshit_gif instance 1', 24, true);
	fgStatic.animation.play('play', true);
	fgStatic.setGraphicSize(FlxG.width);
	fgStatic.updateHitbox();
	fgStatic.screenCenter();
	fgStatic.antialiasing = EngineSettings.antialiasing;
	fgStatic.scrollFactor.set();
	fgStatic.alpha = 0.6;
	fgStatic.cameras = [PlayState.camHUD];
	PlayState.add(fgStatic);
	
    grainShit = new FlxSprite(0,0);
    grainShit.frames = Paths.getSparrowAtlas('Grainshit');
    grainShit.animation.addByPrefix('brrrrr', 'Geain instance 1', 24, true);
    grainShit.animation.play('brrrrr');
    grainShit.antialiasing = EngineSettings.antialiasing;
    grainShit.cameras = [PlayState.camHUD];
	grainShit.screenCenter();
    PlayState.add(grainShit);

    rainLayer01 = new FlxSprite(0,0);
    rainLayer01.frames = Paths.getSparrowAtlas('cuphead/NewRAINLayer01');
    rainLayer01.animation.addByPrefix('imWet', 'RainFirstlayer instance 1', 24, true);
    rainLayer01.animation.play('imWet');
    rainLayer01.antialiasing = EngineSettings.antialiasing;
    rainLayer01.cameras = [PlayState.camHUD];
    PlayState.add(rainLayer01);

    rainLayer02 = new FlxSprite(0,0);
    rainLayer02.frames = Paths.getSparrowAtlas('cuphead/NewRainLayer02');
    rainLayer02.animation.addByPrefix('itsCold', 'RainFirstlayer instance 1', 24, true);
    rainLayer02.animation.play('itsCold');
    rainLayer02.antialiasing = EngineSettings.antialiasing;
    rainLayer02.cameras = [PlayState.camHUD];
    PlayState.add(rainLayer02);
}
function update(elapsed) {
	stage.update(elapsed);

    // FlxG.autoPause = false;
}
function onDeath() {
    persistentDraw = true;

    FlxTween.tween(PlayState.camHUD, {alpha: 0}, 1);
    FlxG.camera.shake(0.005);

    FlxTween.tween(rainLayer01, {alpha: 0}, 1);
    FlxTween.tween(rainLayer02, {alpha: 0}, 1);

    FlxTween.tween(fgStatic, {alpha: 0}, 1);
    FlxTween.tween(grainShit, {alpha: 0}, 1);
}
function beatHit(curBeat) {
	stage.onBeat();
}