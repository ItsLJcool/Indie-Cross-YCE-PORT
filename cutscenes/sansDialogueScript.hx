//a

var daSong = PlayState.song.song.toLowerCase();
function update() {
    PlayState.camFollow.x = 250;
}
var daFunnyPath:String = "mods/" + mod + "/data/" + daSong + "/BurningInHellDialogue/";
function create() {
    if (daSong == 'burning-in-hell' && PlayState.blueballAmount != 0) {
        if (PlayState.blueballAmount <= 11) {
            setDialogueTo(daFunnyPath + "death" + PlayState.blueballAmount + ".json");
        }
        else setDialogueTo(daFunnyPath + "countForMePlease.json");
    }
}