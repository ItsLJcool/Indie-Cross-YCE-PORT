var stage:Stage = null;
function create() {
	stage = loadStage('sansStageIC');
	stage.getSprite("Waterfall").alpha = 1; // im too lazy shut up
}
function update(elapsed) {
	stage.update(elapsed);
}
function beatHit(curBeat) {
	stage.onBeat();
}