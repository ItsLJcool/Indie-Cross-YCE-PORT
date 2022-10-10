//a
var stage:Stage = null;
function create() {
	stage = loadStage('despairStage');
	PlayState.gf.visible = false;
	EngineSettings.botplay = true;
}
function update(elapsed) {
	stage.update(elapsed);
}
function beatHit(curBeat) {
	stage.onBeat();
}