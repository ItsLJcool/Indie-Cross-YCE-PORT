var stage:Stage = null;
function create() {
	stage = loadStage('sansBurningHell');
}
function update(elapsed) {
	stage.update(elapsed);
}
function beatHit(curBeat) {
	stage.onBeat();
}