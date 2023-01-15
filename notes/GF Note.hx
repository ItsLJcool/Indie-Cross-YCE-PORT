//a
function onDadHit(noteData) {
    switch(noteData) {
        case 0:
            PlayState.gf.playAnim("singLEFT", true);
        case 1:
            PlayState.gf.playAnim("singDOWN", true);
        case 2:
            PlayState.gf.playAnim("singUP", true);
        case 3:
            PlayState.gf.playAnim("singRIGHT", true);
    }
}
function onPlayerHit(noteData) {
    switch(noteData) {
        case 0:
            PlayState.gf.playAnim("singLEFT", true);
        case 1:
            PlayState.gf.playAnim("singDOWN", true);
        case 2:
            PlayState.gf.playAnim("singUP", true);
        case 3:
            PlayState.gf.playAnim("singRIGHT", true);
    }
}