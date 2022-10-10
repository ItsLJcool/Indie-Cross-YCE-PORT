var stage:Stage = null;
function create() {
	stage = loadStage('cupheadNightmareStage');
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
	
}
function onDeath() {
    persistentDraw = true;
}
function update(elapsed) {
	stage.update(elapsed);
}
function beatHit(curBeat) {
	stage.onBeat();
}