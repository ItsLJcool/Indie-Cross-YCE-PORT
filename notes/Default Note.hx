enableRating = true;
var song = PlayState.song.song.toLowerCase();
var inCuphead:Bool = false;
function create() {
    if (song == "knockout" || song == "snake-eyes" || song == "technicolor-tussle" || song == "devils-gambit") {
        note.frames = Paths.getSparrowAtlas("notes/Cuphead_Notes"); 
        inCuphead = true; }
    else
        note.frames = Paths.getSparrowAtlas('NOTE_assets_colored', 'shared');

    switch(note.noteData % PlayState.song.keyNumber) {
        case 0:
            note.animation.addByPrefix('scroll', "purple0");
            note.animation.addByPrefix('holdend', "pruple end hold");
            note.animation.addByPrefix('holdpiece', "purple hold piece");
        case 1:
            note.animation.addByPrefix('scroll', "blue0");
            note.animation.addByPrefix('holdend', "blue hold end");
            note.animation.addByPrefix('holdpiece', "blue hold piece");
        case 2:
            note.animation.addByPrefix('scroll', "green0");
            note.animation.addByPrefix('holdend', "green hold end");
            note.animation.addByPrefix('holdpiece', "green hold piece");
        case 3:
            note.animation.addByPrefix('scroll', "red0");
            note.animation.addByPrefix('holdend', "red hold end");
            note.animation.addByPrefix('holdpiece', "red hold piece");
    }
    note.splash = Paths.splashes("splashes/IndieCrossRed");
    note.setGraphicSize(Std.int(note.width * 0.7));
    note.updateHitbox();
    note.antialiasing = true;
    note.colored = true;
    note.hitOnBotplay = true;

    note.animation.play('scroll');
    if (note.isSustainNote) {
        if (note.prevNote != null)
            if (note.prevNote.animation.curAnim.name == "holdend")
                note.prevNote.animation.play("holdpiece");
        note.animation.play("holdend");
    }
}

function onPlayerHit(oof:Int) {
    switch (PlayState.boyfriend.animation.curAnim.name) {
        case "dodge", "attack", "hit": return;
    }
    super.onPlayerHit(oof);
}

function onMiss(oof:Int) {
    switch (PlayState.boyfriend.animation.curAnim.name) {
        case "dodge", "attack", "hit": return;
    }
    super.onMiss(oof);
}

function onDadHit(oof:Int) {
    switch (PlayState.dad.animation.curAnim.name) {
        case "dodge", "attack", "hurt": return;
    }
    super.onDadHit(oof);
}