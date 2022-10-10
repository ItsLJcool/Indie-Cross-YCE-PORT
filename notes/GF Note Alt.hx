//a
function onDadHit(noteData) {
    switch(noteData) {
        case 0:
            PlayState.gf.playAnim("singLEFT-alt", true);
        case 1:
            PlayState.gf.playAnim("singDOWN-alt", true);
        case 2:
            PlayState.gf.playAnim("singUP-alt", true);
        case 3:
            PlayState.gf.playAnim("singRIGHT-alt", true);
    }
}
function onPlayerHit(noteData) {
    switch(noteData) {
        case 0:
            PlayState.gf.playAnim("singLEFT-alt", true);
        case 1:
            PlayState.gf.playAnim("singDOWN-alt", true);
        case 2:
            PlayState.gf.playAnim("singUP-alt", true);
        case 3:
            PlayState.gf.playAnim("singRIGHT-alt", true);
    }
}
