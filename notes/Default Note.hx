enableRating = true;
var song = PlayState.song.song.toLowerCase();
var inCuphead:Bool = false;
function create() {
    if (song == "knockout" || song == "snake-eyes" || song == "technicolor-tussle" || song == "devils-gambit") {
        note.frames = Paths.getSparrowAtlas("notes/NOTE_assets_cuphead"); 
        inCuphead = true; }
    else
        note.frames = Paths.getSparrowAtlas('NOTE_assets_colored', 'shared');

    switch(note.noteData % PlayState.song.keyNumber) {
        case 0:
            note.animation.addByPrefix('scroll', "purple0");
            note.animation.addByPrefix('holdend', "pruple end hold");
            note.animation.addByPrefix('holdpiece', "purple hold piece");
            note.splash = Paths.splashes("splashes/IndieCrossPurple");
        case 1:
            note.animation.addByPrefix('scroll', "blue0");
            note.animation.addByPrefix('holdend', "blue hold end");
            note.animation.addByPrefix('holdpiece', "blue hold piece");
            note.splash = Paths.splashes("splashes/IndieCrossBlue");
        case 2:
            note.animation.addByPrefix('scroll', "green0");
            note.animation.addByPrefix('holdend', "green hold end");
            note.animation.addByPrefix('holdpiece', "green hold piece");
            note.splash = Paths.splashes("splashes/IndieCrossGreen");
        case 3:
            note.animation.addByPrefix('scroll', "red0");
            note.animation.addByPrefix('holdend', "red hold end");
            note.animation.addByPrefix('holdpiece', "red hold piece");
            note.splash = Paths.splashes("splashes/IndieCrossRed");
    }
    note.setGraphicSize(Std.int(note.width * 0.7));
    note.updateHitbox();
    note.antialiasing = true;
    (inCuphead) ? note.colored = false : note.colored = true;
    note.hitOnBotplay = true;

    note.animation.play('scroll');
    if (note.isSustainNote) {
        if (note.prevNote != null)
            if (note.prevNote.animation.curAnim.name == "holdend")
                note.prevNote.animation.play("holdpiece");
        note.animation.play("holdend");
    }
}

function onPlayerHit() {
    for (boy in PlayState.boyfriends) {
        switch(note.noteData % PlayState.song.keyNumber) {
            case 0:
                boy.playAnim("singLEFT", true);
            case 1:
                boy.playAnim("singDOWN", true);
            case 2:
                boy.playAnim("singUP", true);
            case 3:
                boy.playAnim("singRIGHT", true);
        }
    }
}